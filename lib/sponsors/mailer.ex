defmodule Sponsors.Mailer do
  @moduledoc """
  Our Bamboo Mailer
  """

  use Bamboo.Mailer, otp_app: :sponsors
  use Appsignal.Instrumentation.Decorators
  use Spandex.Decorators

  require Logger

  @decorate transaction(:mailgun)
  @decorate span(service: :mailgun, type: :web)
  def send(email) do
    Logger.debug("Sending email: #{email.subject}")
    {:ok, deliver_now(email)}
  rescue
    e in Bamboo.ApiError -> bamboo_error(e)
  end

  defp bamboo_error(%{message: message}) do
    if String.contains?(message, "Sandbox subdomains are for test purposes only") do
      :ignored
    else
      {:error, message}
    end
  end
end
