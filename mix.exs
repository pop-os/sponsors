defmodule Sponsors.MixProject do
  use Mix.Project

  def project do
    [
      app: :sponsors,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Sponsors.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:appsignal, "~> 2.13"},
      {:appsignal_phoenix, "~> 2.0"},
      {:appsignal_plug, "~> 2.0"},
      {:bamboo, "~> 1.6"},
      {:bottle, github: "system76/bottle", ref: "4654c83d58c0323f9ad40a8e3cdab8fe2c0110e6"},
      {:bypass, "~> 1.0", only: :test},
      {:cors_plug, "~> 2.0"},
      {:cowboy, "~> 2.8", override: true},
      {:cowlib, "~> 2.9.1", override: true},
      {:credo, "~> 1.4", only: [:dev, :test]},
      {:decorator, "~> 1.2"},
      {:ecto_sql, "~> 3.1"},
      {:ex_machina, "~> 2.4", only: :test},
      {:guardian, "~> 2.1"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.2", override: true},
      {:logger_json, github: "Nebo15/logger_json", ref: "8e4290a"},
      {:mox, "~> 0.5", only: :test},
      {:plug_cowboy, "~> 2.0"},

      {:phoenix_ecto, "~> 4.1"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_view, "~> 0.20"},
      {:phoenix, "~> 1.7.1"},


      {:postgrex, ">= 0.0.0"},
      {:spandex_datadog, "~> 1.1.0"},
      {:spandex_ecto, "~> 0.6.2"},
      {:spandex_phoenix, "~> 1.0.5"},
      {:spandex, "~> 3.0.3"},
      {:stripity_stripe, "~> 2.8"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
