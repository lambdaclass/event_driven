defmodule ApiServiceWeb.ApiController do
  use ApiServiceWeb, :controller
  require Logger

  @listings_topic "listings"

  def create_item(conn, %{"item_id" => item_id, "price" => price, "buyer_id" => buyer_id}) do
    KafkaEx.produce(
      @listings_topic,
      0,
      Jason.encode!(%{
        "event" => "listing_intent",
        "item_id" => item_id,
        "price" => price,
        "buyer_id" => buyer_id
      })
    )

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(:ok, Jason.encode!(%{"status" => "ok"}))
  end

  def list_items(conn, params) do
    {:ok, request_id} = get_request_id(conn)

    KafkaEx.produce(
      @listings_topic,
      0,
      Jason.encode!(%{
        "event" => "listing_list",
        "request_id" => request_id,
        "params" => params
      })
    )

    # Wait for the event response dispatch
    {:ok, data} = wait_response_dispatch(request_id)

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(:ok, Jason.encode!(%{"status" => "ok", "data" => data}))
  end

  # The "x-request-id" header is set at `resp_headers` by `Plug.RequestId`
  # and it should already have the value received at `req_headers`
  defp get_request_id(conn) do
    case Plug.Conn.get_resp_header(conn, "x-request-id") do
      [request_id] -> {:ok, request_id}
      # This should not happen since `Plug.RequestId` is automatically included at `endpoint.ex`
      _empty -> {:error, :missing_request_id}
    end
  end

  # Wait for the event response dispatch
  defp wait_response_dispatch(request_id, timeout \\ 5_000) do
    # Register current PID+request_id
    {:ok, _} = Registry.register(Registry.RequestIdPID, request_id, [])
    Logger.info("Waiting event response for request_id=#{request_id}..")

    receive do
      response -> response
    after
      timeout -> {:error, :timeout}
    end
  end
end
