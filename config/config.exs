# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sponsors,
  ecto_repos: [Sponsors.Repo]

# Configures the endpoint
config :sponsors, SponsorsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2LPO+CQyfjtZ4/a65vUBXlmjzR1ZpoAHhJl322u/PkrjuFagAzHoJOmbGYHLuzL7",
  render_errors: [view: SponsorsWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Sponsors.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "9vTKcTFZ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
