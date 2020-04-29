defmodule Sponsors.Repo.Migrations.AddSubscriptionExpiration do
  use Ecto.Migration

  def change do
    alter table(:invoices) do
      remove :subscription_id
    end

    flush()

    alter table(:subscriptions) do
      remove :id
      remove :canceled

      add :id, :uuid, primary_key: true
      add :expires_at, :utc_datetime
      add :canceled_at, :utc_datetime
    end

    alter table(:invoices) do
      remove :id

      add :id, :uuid, primary_key: true
      add :subscription_id, references(:subscriptions, type: :uuid)
    end
  end
end
