# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :sponsors,
  ecto_repos: [Sponsors.Repo],
  stripe_module: Sponsors.Stripe,
  stripe_signing_secret: "stripe_webhook_secret",
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
  metadata: [:request_id, :user_id, :trace_id, :span_id]

config :logger_json, :backend,
  formatter: LoggerJSON.Formatters.DatadogLogger,
  metadata: :all

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :sponsors, Sponsors.Guardian,
  issuer: "system76",
  secret_key: "averysecretsecret"

config :stripity_stripe, api_key: "stripe_secret_key"

config :appsignal, :config,
  active: false,
  name: "Sponsors",
  ignore_errors: [
    "Ecto.NoResultsError",
    "Phoenix.MissingParamError",
    "Phoenix.Router.NoRouteError"
  ]

config :sponsors, Sponsors.Tracer,
  service: :sponsors,
  adapter: SpandexDatadog.Adapter,
  disabled?: true

config :sponsors, SpandexDatadog.ApiServer,
  http: HTTPoison,
  host: "127.0.0.1"

config :spandex_ecto, SpandexEcto.EctoLogger,
  service: :sponsors,
  tracer: Sponsors.Tracer

config :spandex_phoenix, tracer: Sponsors.Tracer
config :spandex, :decorators, tracer: Sponsors.Tracer

config :sponsors, Sponsors.Mailer, adapter: Bamboo.LocalAdapter

config :sponsors, slack_webhook: nil

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
