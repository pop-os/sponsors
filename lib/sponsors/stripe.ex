defmodule Sponsors.Stripe do
  @moduledoc """
  The business logic for interacting with Stripe in order to subscribe customers to a plan
  """
  @callback subscribe(String.t()) :: {:ok, String.t()} | {:error, atom() | any()}

  def cancel(id), do: Stripe.Subscription.delete(id)

  def subscribe(stripe_customer_id) do
    params = %{
      customer: stripe_customer_id,
      items: [%{plan: subscription_plan()}]
    }

    case Stripe.Subscription.create(params) do
      {:ok, %{id: stripe_subscription_id, status: "active"}} -> {:ok, stripe_subscription_id}
      {:ok, %{status: "incomplete"}} -> {:error, :stripe_payment_failed}
      {:error, _errors} -> {:error, :stripe_error}
    end
  end

  defp subscription_plan, do: Application.get_env(:sponsors, :subscription_plan)
end
