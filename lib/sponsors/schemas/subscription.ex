defmodule Sponsors.Schemas.Subscription do
  @moduledoc """
  Our `subscriptions` table schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Sponsors.Schemas.Invoice

  @primary_key {:id, :binary_id, autogenerate: true}

  @type t :: %{
          canceled_at: DateTime.utc(),
          customer_id: String.t(),
          expires_at: DateTime.t(),
          inserted_at: DateTime.t(),
          stripe_subscription_id: String.t(),
          updated_at: DateTime.t()
        }

  schema "subscriptions" do
    field :canceled_at, :utc_datetime
    field :customer_id, :string
    field :expires_at, :utc_datetime
    field :stripe_subscription_id, :string

    has_many :invoices, Invoice

    timestamps()
  end

  def changeset(subscription, params) do
    subscription
    |> cast(params, [:canceled_at, :customer_id, :expires_at, :stripe_subscription_id])
    |> validate_required([:customer_id, :expires_at, :stripe_subscription_id])
    |> unique_constraint(:stripe_subscription_id)
  end
end
