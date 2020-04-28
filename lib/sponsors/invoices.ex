defmodule Sponsors.Invoices do
  @moduledoc """
  Provides a simple interface for interacting with the `invoices` table
  """

  alias Sponsors.{Email, Mailer, Repo}
  alias Sponsors.Schemas.{Invoice, Subscription}

  def create(stripe_invoice_id, stripe_subscription_id, stripe_customer_id, paid) do
    with %{id: subscription_id} <- Repo.get_by(Subscription, stripe_subscription_id: stripe_subscription_id),
         params = %{paid: paid, stripe_invoice_id: stripe_invoice_id, subscription_id: subscription_id},
         changeset = Invoice.changeset(%Invoice{}, params),
         {:ok, _invoice} <- Repo.insert(changeset),
         {:ok, %{email: email, name: full_name}} <- stripe().customer(stripe_customer_id) do
      name = first_name(full_name)

      email
      |> Email.thank_you(name)
      |> Mailer.deliver_now()

      :ok
    end
  end

  defp first_name(name) do
    name
    |> String.split(" ", parts: 2)
    |> List.first()
  end

  defp stripe, do: Application.get_env(:sponsors, :stripe_module)
end
