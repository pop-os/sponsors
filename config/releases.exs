import Config

config =
  "CONFIG"
  |> System.fetch_env!()
  |> Jason.decode!()

config :sponsors, SponsorsWeb.Endpoint, secret_key_base: config["SECRET_KEY_BASE"]

config :sponsors, Sponsors.Repo,
  database: config["DB_NAME"],
  username: config["DB_USERNAME"],
  password: config["DB_PASSWORD"],
  hostname: config["DB_HOST"]

config :sponsors, Sponsors.Mailer, api_key: config["MAILGUN_KEY"]

config :sponsors,
  stripe_signing_secret: config["STRIPE_WEBHOOK_SECRET"],
  subscription_plan: config["STRIPE_SUBSCRIPTION_PLAN"]

config :stripity_stripe, api_key: config["STRIPE_SECRET_KEY"]

config :sponsors, Sponsors.Guardian, secret_key: config["JWT_SECRET_KEY"]

config :appsignal, :config,
  active: Map.get(config, "APPSIGNAL_ENABLED", false),
  push_api_key: config["APPSIGNAL_PUSH_KEY"],
  env: config["APPSIGNAL_ENV"]

config :sponsors,
  slack_webhook: Map.get(config, "SLACK_WEBHOOK", nil)
