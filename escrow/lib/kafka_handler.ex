defmodule Escrow.KafkaHandler do
  use Broadway

  alias Broadway.Message
  require Logger

  @escrow_topic "escrow"

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: [localhost: 9092, localhost: 9093, localhost: 9094],
             group_id: "escrow_service",
             topics: [@escrow_topic]
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

  defp handle_data(%{"event" => "item_escrow"} = data) do
    %{"item_id" => item_id, "price" => price} = data

    Logger.info("Escrowing item with id #{item_id} with price #{price}")
    Process.sleep(5_000)

    escrow_event = %{
      "event" => "item_escrowed",
      "item_id" => item_id,
      "price" => "price"
    }

    :ok = KafkaEx.produce(@escrow_topic, 0, Jason.encode!(escrow_event))

    {:ok, _} =
      Escrow.Escrow.create(%{
        item_id: item_id
      })
  end

  defp handle_data(%{"event" => "item_escrowed"}) do
    :nothing
  end

  defp handle_data(data) do
    Logger.error("Unhandled message: #{inspect(data)}")
  end
end
