import Config

# Configure your database
config :sponsors, Sponsors.Repo,
  username: "postgres",
  password: "postgres",
  database: "sponsors_test",
  hostname: Map.get(System.get_env(), "DB_HOST", "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sponsors, SponsorsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :sponsors,
  stripe_module: Sponsors.StripeMock,
  subscription_module: Sponsors.SubscriptionsMock
