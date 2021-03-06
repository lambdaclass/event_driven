defmodule Marketplace.MixProject do
  use Mix.Project

  def project do
    [
      app: :marketplace,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Marketplace.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:postgrex, "~> 0.16.3"},
      {:ecto_sql, "~> 3.8.2"},
      {:ecto, "~> 3.7"},
      {:jason, "~> 1.3"},
      {:broadway_kafka, "~> 0.3"},
      {:kafka_ex, "~> 0.11"}
    ]
  end
end
