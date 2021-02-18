defmodule SponsorsWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
    error_handler: SponsorsWeb.FallbackController,
    module: Sponsors.Guardian,
    otp_app: :sponsors

  plug Guardian.Plug.VerifyHeader, claims: %{"iss" => "system76", "typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug :set_metadata

  defp set_metadata(conn, _params) do
    if user_id = Guardian.Plug.current_resource(conn) do
      Logger.metadata(user_id: user_id)
    end

    conn
  end
end
