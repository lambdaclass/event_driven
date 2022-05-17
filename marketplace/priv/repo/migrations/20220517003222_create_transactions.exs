defmodule Marketplace.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :transaction_id, :string

      timestamps()
    end
  end
end
