defmodule Escrow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Escrow.Worker.start_link(arg)
      # {Escrow.Worker, arg}
      Escrow.Repo,
      Escrow.KafkaHandler
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Escrow.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
