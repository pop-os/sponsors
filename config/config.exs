# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sponsors,
  ecto_repos: [Sponsors.Repo],
  stripe_module: Sponsors.Stripe,
  stripe_secret: "stripe_webhook_secret",
  subscription_module: Sponsors.Subscriptions,
  subscription_plan: "stripe_plan"

# Configures the endpoint
config :sponsors, SponsorsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2LPO+CQyfjtZ4/a65vUBXlmjzR1ZpoAHhJl322u/PkrjuFagAzHoJOmbGYHLuzL7",
  render_errors: [view: SponsorsWeb.ErrorView, accepts: ~w(json)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :sponsors, Sponsors.Guardian,
  issuer: "system76",
  secret_key: System.get_env("JWT_SECRET_KEY", "averysecretsecret")

config :stripity_stripe, api_key: "stripe_secret_key"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
