defmodule SponsorsWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :sponsors
  use Appsignal.Phoenix

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_sponsors_key",
    signing_salt: "Q3dlFHYr"
  ]

  plug SponsorsWeb.HealthcheckPlug

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Bottle.RequestIdPlug
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug LoggerJSON.Plug,
    metadata_formatter: LoggerJSON.Plug.MetadataFormatters.DatadogLogger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    body_reader: {SponsorsWeb.CacheBodyReader, :read_body, []},
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug CORSPlug, headers: ["*"], origin: ["*"]
  plug Plug.Session, @session_options

  plug SponsorsWeb.Router
end
