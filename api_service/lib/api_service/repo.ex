defmodule ApiService.Repo do
  use Ecto.Repo,
    otp_app: :api_service,
    adapter: Ecto.Adapters.Postgres
end
