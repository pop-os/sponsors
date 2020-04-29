defmodule Sponsors.Subscriptions do
  @moduledoc """
  A collection of functions encapsulating the business logic for subscriptions
  """

  import Ecto.Query

  alias Sponsors.Schemas.Subscription
  alias Sponsors.Repo

  @callback all(String.t()) :: [Subscription.t()]
  @callback cancel(String.t()) :: :ok | {:error, :subscription_cancelation_failed | :subscription_not_found}
  @callback create(String.t(), String.t(), String.t() | nil) :: {:ok, Subscription.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Find existing subscriptions for a customer if it exists
  """
  def all(customer_id) do
    query =
      from s in Subscription,
        where: is_nil(s.canceled_at),
        where: s.customer_id == ^customer_id

    Repo.all(query)
  end

  @doc """
  Create a Stripe subscription and persist it to our database
  """
  def create(stripe_customer_id, internal_customer_id, source) do
    with {:ok, subscription} <- stripe().subscribe(stripe_customer_id, source) do
      params = %{
        customer_id: internal_customer_id,
        expires_at: DateTime.from_unix!(subscription.current_period_end),
        stripe_source_id: source,
        stripe_subscription_id: subscription.id
      }

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
