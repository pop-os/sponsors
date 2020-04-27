defmodule Sponsors.Schemas.Subscription do
  @moduledoc """
  Our `subscriptions` table schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Sponsors.Schemas.Invoice

  @type t :: %{
          canceled: boolean(),
          customer_id: String.t(),
          inserted_at: DateTime.t(),
          stripe_subscription_id: String.t(),
          updated_at: DateTime.t()
        }

  schema "subscriptions" do
    field :canceled, :boolean
    field :customer_id, :string
    field :stripe_subscription_id, :string

    has_many :invoices, Invoice

    timestamps()
  end

  def changeset(subscription, params) do
    subscription
    |> cast(params, [:canceled, :customer_id, :stripe_subscription_id])
    |> validate_required([:customer_id, :stripe_subscription_id])
    |> unique_constraint(:stripe_subscription_id)
  end
end
