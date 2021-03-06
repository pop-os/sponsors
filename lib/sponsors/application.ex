defmodule Sponsors.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    SpandexPhoenix.Telemetry.install()

    # List all child processes to be supervised
    children = [
      {SpandexDatadog.ApiServer, Application.get_env(:sponsors, SpandexDatadog.ApiServer)},
      # Start the Ecto repository
      Sponsors.Repo,
      # Start the Telemetry application
      SponsorsWeb.Telemetry,
      # Start the endpoint when the application starts
      SponsorsWeb.Endpoint
      # Starts a worker by calling: Sponsors.Worker.start_link(arg)
      # {Sponsors.Worker, arg},
    ]

    :telemetry.attach(
      "appsignal-ecto",
      [:sponsors, :repo, :query],
      &Appsignal.Ecto.handle_event/4,
      nil
    )

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sponsors.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SponsorsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
