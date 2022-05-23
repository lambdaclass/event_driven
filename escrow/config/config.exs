import Config

config :escrow, :ecto_repos, [Escrow.Repo]

import_config "#{Mix.env()}.exs"
