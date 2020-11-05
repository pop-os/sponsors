import Config

config =
  "CONFIG"
  |> System.fetch_env!()
  |> Jason.decode!()

config :sponsors, SponsorsWeb.Endpoint, secret_key_base: config["SECRET_KEY_BASE"]

config :sponsors, Sponsors.Repo,
  database: database_config["DB_NAME"],
  username: database_config["DB_USERNAME"],
  password: database_config["DB_PASSWORD"],
  hostname: database_config["DB_HOST"]

config :sponsors, Sponsors.Mailer, api_key: config["MAILGUN_KEY"]

config :sponsors,
  stripe_signing_secret: config["STRIPE_WEBHOOK_SECRET"],
  subscription_plan: config["STRIPE_SUBSCRIPTION_PLAN"]

config :stripity_stripe, api_key: config["STRIPE_SECRET_KEY"]

config :sponsors, Sponsors.Guardian, secret_key: config["JWT_SECRET_KEY"]

# Since we do not include AppSignal reporting in all ENVs we need to handle their
# configuration slightly differently.
appsignal_defaults = %{
  "active" => false,
  "push_api_key" => "",
  "env" => "prod"
}

appsignal_secrets =
  "APPSIGNAL_SECRETS"
  |> System.get_env("{}")
  |> Jason.decode!()

appsignal_config = Map.merge(appsignal_defaults, appsignal_secrets)

config :appsignal, :config,
  active: Map.get(config, "APPSIGNAL_ENABLED", false),
  push_api_key: config["APPSIGNAL_PUSH_KEY"],
  env: config["APPSIGNAL_ENV"]

config :sponsors,
  slack_webhook: Map.get(config, "SLACK_WEBHOOK", nil)
