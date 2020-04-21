defmodule Sponsors.Invoices do
  @moduledoc """
  Provides a simple interface for interacting with the `invoices` table
  """

  alias Sponsors.Repo
  alias Sponsors.Schemas.{Invoice, Subscription}

  def create(stripe_invoice_id, stripe_subscription_id, paid) do
    with %{id: subscription_id} <- Repo.get_by(Subscription, stripe_subscription_id: stripe_subscription_id) do
      params = %{paid: paid, stripe_invoice_id: stripe_invoice_id, subscription_id: subscription_id}
      changeset = Invoice.changeset(%Invoice{}, params)

      Repo.insert(changeset)
    end
  end
end
