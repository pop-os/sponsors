defmodule Sponsors.Invoices do
  @moduledoc """
  Provides a simple interface for interacting with the `invoices` table
  """

  alias Sponsors.Repo
  alias Sponsors.Schemas.{Invoice, Subscription}

  def create(stripe_invoice_id, stripe_subscription_id, expires_at, paid) do
    with %{id: subscription_id} = subscription <- get_subscription(stripe_subscription_id),
         {:ok, invoice} <- record_invoice(stripe_invoice_id, subscription_id, paid) do
      update_subscription_expiration(subscription, expires_at)
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
end
