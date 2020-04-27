defmodule Sponsors.Subscriptions do
  @moduledoc """
  A collection of functions encapsulating the business logic for subscriptions
  """

  alias Sponsors.Schemas.Subscription
  alias Sponsors.Repo

  @callback cancel(String.t()) :: :ok | {:error, :subscription_cancelation_failed | :subscription_not_found}

  @callback create(String.t(), String.t()) :: {:ok, Subscription.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Create a Stripe subscription and persist it to our database
  """
  def create(stripe_customer_id, internal_customer_id) do
    with {:ok, stripe_subscription_id} <- stripe().subscribe(stripe_customer_id) do
      params = %{customer_id: internal_customer_id, stripe_subscription_id: stripe_subscription_id}

      %Subscription{}
      |> Subscription.changeset(params)
      |> Repo.insert()
    end
  end

  @doc """
  Cancel a subscription and update the database's record
  """
  def cancel(id) do
    with %{stripe_subscription_id: stripe_subscription_id} = subscription <- Repo.get(Subscription, id),
         changeset = Subscription.changeset(subscription, %{canceled: true}),
         {:ok, _deleted_subscription} <- Repo.update(changeset),
         {:ok, _canceled_subscription} <- stripe().cancel(stripe_subscription_id) do
      :ok
    else
      nil -> {:error, :subscription_not_found}
      _error -> {:error, :subscription_cancelation_failed}
    end
  end

  defp stripe, do: Application.get_env(:sponsors, :stripe_module)
end
