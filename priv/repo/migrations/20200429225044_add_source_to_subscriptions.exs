defmodule Sponsors.Repo.Migrations.AddSourceToSubscriptions do
  use Ecto.Migration

  def change do
    alter table(:subscriptions) do
      add :stripe_source_id, :string, null: false
    end
  end
end
