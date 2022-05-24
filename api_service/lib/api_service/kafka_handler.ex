defmodule ApiService.KafkaHandler do
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
             group_id: "api_service",
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

  defp handle_data(%{"event" => "listing_list_result", "request_id" => request_id, "items" => items}) do
    Logger.info("Returning #{length(items)} listing items...")

    dispatch(request_id, {:ok, items})
  end

  defp handle_data(data) do
    Logger.error("Unhandled message: #{inspect(data)}")
  end

  defp dispatch(request_id, data) do
    Registry.dispatch(Registry.RequestIdPID, request_id, fn entries ->
      for {pid, _} <- entries, do: send(pid, data)
    end)
  end
end
