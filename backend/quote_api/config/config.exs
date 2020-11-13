# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :quote_api,
  ecto_repos: [QuoteApi.Repo]

# Configures the endpoint
config :quote_api, QuoteApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hbIWN2w72hDihVSx3RNDeohwRXxZW3IDXzGpr6DznHLOWHge9iDiU9KRMs7p0P4P",
  render_errors: [view: QuoteApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: QuoteApi.PubSub,
  live_view: [signing_salt: "an7q4i7K"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :quote_api, QuoteApiWeb.Auth.Guardian,
  issuer: "quote_api",
  secret_key: "DZuI5Awxw4zT0YhRR/UgsUDJJmxKrsmd2iWbmE6mz6saE2rP7KjSmZxMcBpVaNTe"