defmodule ApiServiceWeb.ApiController do
  use ApiServiceWeb, :controller

  @listings_topic "listings"

  def list(conn, %{"item_id" => item_id, "price" => price, "buyer_id" => buyer_id}) do
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
end
