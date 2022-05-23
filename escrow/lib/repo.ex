defmodule Escrow.Repo do
  use Ecto.Repo,
    otp_app: :escrow,
    adapter: Ecto.Adapters.Postgres
end
