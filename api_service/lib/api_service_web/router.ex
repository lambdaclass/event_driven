defmodule ApiServiceWeb.Router do
  use ApiServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiServiceWeb do
    pipe_through :api

    post "/item/buy", ApiController, :buy
  end
end
