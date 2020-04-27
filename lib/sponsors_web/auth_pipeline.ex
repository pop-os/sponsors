defmodule SponsorsWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
    error_handler: SponsorsWeb.FallbackController,
    module: Sponsors.Guardian,
    otp_app: :sponsors

  plug Guardian.Plug.VerifyHeader, claims: %{"iss" => "system76", "typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
end
