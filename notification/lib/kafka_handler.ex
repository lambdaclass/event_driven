defmodule Notification.KafkaHandler do
  use Broadway

  alias Broadway.Message
  require Logger

  @listings_topic "listings"

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: [localhost: 9092, localhost: 9093, localhost: 9094],
             group_id: "notification_service",
             topics: [@listings_topic]
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

  defp handle_data(%{"event" => "listing_published"} = data) do
    %{"item_id" => item_id} = data

    Logger.info("Notifying of listing of item with id #{item_id}")
  end

  defp handle_data(%{"event" => "listing_intent"}) do
    :nothing
  end

  defp handle_data(data) do
    Logger.error("Unhandled message: #{inspect(data)}")
  end
end
