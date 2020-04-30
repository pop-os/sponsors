defmodule Sponsors.Invoices do
  @moduledoc """
  Provides a simple interface for interacting with the `invoices` table
  """

  alias Sponsors.{Email, Mailer, Repo}
  alias Sponsors.Schemas.{Invoice, Subscription}

  def create(stripe_invoice_id, stripe_subscription_id, stripe_customer_id, expires_at, paid) do
    with %{id: subscription_id} = subscription <- get_subscription(stripe_subscription_id),
         {:ok, invoice} <- record_invoice(stripe_invoice_id, subscription_id, paid),
         {:ok, _subscription} <- update_subscription_expiration(subscription, expires_at),
         {:ok, %{email: email, name: full_name}} <- stripe().customer(stripe_customer_id) do
      name = first_name(full_name)

      email
      |> Email.thank_you(name)
      |> Mailer.deliver_now()

      {:ok, invoice}
    end
  end

  defp get_subscription(stripe_subscription_id),
    do: Repo.get_by(Subscription, stripe_subscription_id: stripe_subscription_id)

  defp record_invoice(stripe_invoice_id, subscription_id, paid) do
    params = %{paid: paid, stripe_invoice_id: stripe_invoice_id, subscription_id: subscription_id}

    changeset = Invoice.changeset(%Invoice{}, params)
    Repo.insert(changeset)
  end

  defp update_subscription_expiration(subscription, expires_at) do
    subscription
    |> Subscription.changeset(%{expires_at: DateTime.from_unix!(expires_at)})
    |> Repo.update()
  end

  defp first_name(nil) do
    "Pop!_OS Supporter"
  end

  defp first_name(name) do
    name
    |> String.split(" ", parts: 2)
    |> List.first()
  end

  defp stripe, do: Application.get_env(:sponsors, :stripe_module)
end
