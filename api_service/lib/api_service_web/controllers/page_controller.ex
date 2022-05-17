defmodule ApiServiceWeb.PageController do
  use ApiServiceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
