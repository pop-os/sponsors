defmodule Sponsors.Schemas.Invoice do
  @moduledoc """
  Our `invoices` table schema
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias Sponsors.Schemas.Subscription

  schema "invoices" do
    field :paid, :boolean
    field :stripe_invoice_id, :string

    belongs_to :subscription, Subscription

    timestamps()
  end

  def changeset(subscription, params) do
    subscription
    |> cast(params, [:paid, :stripe_invoice_id, :subscription_id])
    |> validate_required([:paid, :stripe_invoice_id, :subscription_id])
    |> assoc_constraint(:subscription)
    |> unique_constraint(:stripe_invoice_id)
  end
end
