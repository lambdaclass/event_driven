import Config

config :marketplace, :ecto_repos, [Marketplace.Repo]

import_config "#{Mix.env()}.exs"
