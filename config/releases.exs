import Config

config :sponsors, SponsorsWeb.Endpoint, secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

database_config =
  "DB_SECRETS"
  |> System.fetch_env!()
  |> Jason.decode!()

config :sponsors, Sponsors.Repo,
  database: database_config["dbname"],
  username: database_config["username"],
  password: database_config["password"],
  hostname: database_config["host"]

config :sponsors, Sponsors.Mailer, api_key: System.fetch_env!("MAILGUN_API_KEY")

stripe_config =
  "STRIPE_SECRETS"
  |> System.fetch_env!()
  |> Jason.decode!()

config :sponsors,
  stripe_signing_secret: stripe_config["webhook_secret"],
  subscription_plan: stripe_config["subscription_plan"]

config :stripity_stripe, api_key: stripe_config["secret_key"]

config :sponsors, Sponsors.Guardian, secret_key: System.fetch_env!("JWT_SECRET_KEY")

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
  active: appsignal_config["active"],
  push_api_key: appsignal_config["push_api_key"],
  env: appsignal_config["env"]

slack_secrets =
  "SLACK_SECRETS"
  |> System.get_env("{}")
  |> Jason.decode!()

config :sponsors,
  slack_webhook: Map.get(slack_secrets, "subscriptions_webhook_url", nil)
