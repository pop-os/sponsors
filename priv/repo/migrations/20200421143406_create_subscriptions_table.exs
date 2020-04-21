defmodule Sponsors.Repo.Migrations.CreateSubscriptionsTable do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :canceled, :boolean, default: false
      add :customer_id, :string, null: false
      add :stripe_subscription_id, :string, null: false

      timestamps()
    end

    create unique_index(:subscriptions, [:stripe_subscription_id])

    create table(:invoices) do
      add :subscription_id, references(:subscriptions)
      add :stripe_invoice_id, :string, null: false
      add :paid, :boolean, default: false

      timestamps()
    end

    create unique_index(:invoices, [:stripe_invoice_id])
  end
end
