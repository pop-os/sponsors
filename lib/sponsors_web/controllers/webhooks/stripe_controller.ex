defmodule SponsorsWeb.Webhooks.StripeController do
  use SponsorsWeb, :controller

  alias Sponsors.Invoices

  @supported_event_types ["invoice.payment_succeeded", "invoice.payment_failed"]

  def create(conn, _params) do
    raw_body = conn.private[:raw_body]

    with [signature] <- get_req_header(conn, "stripe-signature"),
         {:ok, event} <- Stripe.Webhook.construct_event(raw_body, signature, stripe_signing_secret()),
         true <- event.type in @supported_event_types,
         {invoice_id, stripe_subscription_id, stripe_customer_id, expires_at, paid} <- invoice_details(event) do
      Invoices.create(invoice_id, stripe_subscription_id, stripe_customer_id, expires_at, paid)
    end

    text(conn, "Thanks!")
  end

  defp invoice_details(%{data: %{object: %{customer: customer, id: invoice_id, lines: lines, paid: paid}}}) do
    [%{period: %{end: expires_at}, subscription: stripe_subscription_id}] = lines.data

    {invoice_id, stripe_subscription_id, customer, expires_at, paid}
  end

  defp stripe_signing_secret, do: Application.get_env(:sponsors, :stripe_signing_secret)
end
