defmodule Sponsors.Stripe do
  @moduledoc """
  The business logic for interacting with Stripe in order to subscribe customers to a plan
  """

  @callback cancel(integer()) :: :ok | {:error, String.t()}
  @callback subscribe(String.t()) :: {:ok, Stripe.Subscription.t()} | {:error, atom()}

  def cancel(id), do: Stripe.Subscription.delete(id)

  def subscribe(stripe_customer_id) do
    params = %{
      customer: stripe_customer_id,
      items: [%{plan: subscription_plan()}]
    }

    case Stripe.Subscription.create(params) do
      {:ok, %{status: "active"} = subscription} ->
        {:ok, subscription}

      {:ok, %{status: "incomplete"}} ->
        {:error, :stripe_payment_failed}

      {:error, _errors} ->
        {:error, :stripe_error}
    end
  end

  defp subscription_plan, do: Application.get_env(:sponsors, :subscription_plan)
end
