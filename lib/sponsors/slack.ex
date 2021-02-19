defmodule Sponsors.Slack do
  @moduledoc """
  Send a message to Slack whenever someone subscribes
  """

  use Appsignal.Instrumentation.Decorators
  use Spandex.Decorators

  @decorate transaction(:slack)
  @decorate span(service: :slack, type: :web)
  def send_notification do
    body = %{
      channel: "#subscriptions",
      username: "Pop!_OS Donations",
      icon_emoji: ":pop:",
      text: "Hooray! :tada: Another supporter has joined the Pop!_OS ranks."
    }

    slack_webhook = Application.get_env(:sponsors, :slack_webhook)

    if is_binary(slack_webhook) do
      HTTPoison.post(slack_webhook, Jason.encode!(body), [{"Content-Type", "application/json"}])
    end
  end
end
