defmodule ApiServiceWeb.Router do
  use ApiServiceWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiServiceWeb do
    pipe_through :api

    post "/item/list", ApiController, :create_item
    get "/item/list", ApiController, :list_items
  end
end
