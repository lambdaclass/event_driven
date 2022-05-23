defmodule Escrow.Repo.Migrations.CreateEscrows do
  use Ecto.Migration

  def change do
    create table(:escrows) do
      add :item_id, :string

      timestamps()
    end
  end
end
