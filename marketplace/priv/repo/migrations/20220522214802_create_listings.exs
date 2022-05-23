defmodule Marketplace.Repo.Migrations.CreateListings do
  use Ecto.Migration

  def change do
    create table(:listings) do
      add :status, :string
      add :item_id, :string

      timestamps()
    end
  end
end
