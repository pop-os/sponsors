defmodule SponsorsWeb.HealthCheckController do
  @moduledoc """
  A basic health check endpoint
  """

  use SponsorsWeb, :controller

  def health_check(conn, _opts) do
    json(conn, %{msg: "hi"})
  end
end
