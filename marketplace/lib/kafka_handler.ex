defmodule Marketplace.KafkaHandler do
  use Broadway

  alias Broadway.Message
  require Logger

  @listings_topic "listings"
  @escrow_topic "escrow"

  ## FLOW:
  ## listing_intent published --> Listing created in marketplace --> item_escrow published --> Escrow done in escrow service -->
  ## asset_escrowed published --> Listing published in marketplace --> listing_published published --> picked up by notif service and notified

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: [localhost: 9092, localhost: 9093, localhost: 9094],
             group_id: "marketplace_service",
             topics: [@listings_topic, @escrow_topic]
           ]},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 10
        ]
      ],
      batchers: []
    )
  end

  ## @TODO: Retrieve topic from message and use it to pattern match here maybe
  @impl true
  def handle_message(_, message, _) do
    {:ok, data} = Jason.decode(message.data)
    handle_data(data)
    message
  end

  defp handle_data(%{"event" => "listing_intent"} = data) do
    %{"buyer_id" => buyer_id, "item_id" => item_id, "price" => price} = data

    Logger.info(
      "Creating listing for item with id #{item_id} for price #{price} by the buyer #{buyer_id}"
    )

    Process.sleep(5_000)

    escrow_event = %{
      "event" => "item_escrow",
      "item_id" => item_id,
      "price" => price
    }

    :ok = KafkaEx.produce(@escrow_topic, 0, Jason.encode!(escrow_event))

    {:ok, _} =
      Marketplace.Listing.create(%{
        status: "created",
        item_id: item_id
      })
  end

  defp handle_data(%{"event" => "item_escrowed"} = data) do
    %{"item_id" => item_id, "price" => price} = data

    Logger.info("Updating listing to \"published\" for item with id #{item_id}")
    Process.sleep(5_000)

    listing_event = %{
      "event" => "listing_published",
      "item_id" => item_id,
      "price" => price
    }

    :ok = KafkaEx.produce(@listings_topic, 1, Jason.encode!(listing_event))

    {:ok, _} = Marketplace.Listing.set_as_published(item_id)
  end

  defp handle_data(%{"event" => "listing_list", "request_id" => request_id, "params" => params}) do
    Logger.info("Getting listing items with params: #{inspect(params)}")

    items = Marketplace.Listing.list(params)
    list_event = %{
      "event" => "listing_list_result",
      "request_id" => request_id,
      "items" => items
    }

    Logger.info("Returning #{length(items)} listing items...")
    :ok = KafkaEx.produce(@listings_topic, 0, Jason.encode!(list_event))
  end

  defp handle_data(%{"event" => "item_escrow"} = data) do
    :nothing
  end

  defp handle_data(%{"event" => "listing_published"} = data) do
    :nothing
  end

  defp handle_data(data) do
    Logger.error("Unhandled message: #{inspect(data)}")
  end
end
