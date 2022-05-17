defmodule ApiServiceWeb.ApiController do
  use ApiServiceWeb, :controller

  @purchases_topic "purchases"

  def buy(conn, %{"item_id" => item_id, "amount" => amount, "buyer_id" => buyer_id}) do
    KafkaEx.produce(
      @purchases_topic,
      0,
      Jason.encode!(%{
        "status" => "awaiting_transfer",
        "item_id" => item_id,
        "amount" => amount,
        "buyer_id" => buyer_id
      })
    )

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(:ok, Jason.encode!(%{"status" => "ok"}))
  end
end
