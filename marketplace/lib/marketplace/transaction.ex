defmodule Marketplace.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Marketplace.Repo

  schema "transactions" do
    field :transaction_id, :string

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:transaction_id])
    |> validate_required([:transaction_id])
  end

  def create(attrs) do
    %__MODULE__{}
    |> __MODULE__.changeset(attrs)
    |> Repo.insert()
  end
end
