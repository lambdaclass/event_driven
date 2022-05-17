defmodule Marketplace.KafkaHandler do
  use Broadway

  alias Broadway.Message
  alias Marketplace.Transaction
  require Logger

  @purchases_topic "purchases"

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: [localhost: 9092, localhost: 9093, localhost: 9094],
             group_id: "group_1",
             topics: [@purchases_topic]
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

  @impl true
  def handle_message(_, message, _) do
    {:ok, data} = Jason.decode(message.data)
    handle_data(data)
    message
  end

  defp handle_data(%{"status" => "awaiting_transfer"} = data) do
    %{"buyer_id" => buyer_id, "item_id" => item_id, "amount" => amount} = data

    Logger.info("Transferring #{amount} items with id #{item_id} to the buyer #{buyer_id}")

    transaction_id = Enum.random(1..999_999_999_999) |> Integer.to_string(16)

    Marketplace.Transaction.create(%{
      transaction_id: transaction_id
    })

    updated_data =
      data
      |> Map.put("status", "transfer_complete")
      |> Map.put(
        "transaction_id",
        transaction_id
      )

    KafkaEx.produce(@purchases_topic, 0, Jason.encode!(updated_data))
  end

  defp handle_data(data) do
    Logger.info(data)
  end
end
