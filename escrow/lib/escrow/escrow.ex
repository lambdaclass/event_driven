defmodule Escrow.Escrow do
  use Ecto.Schema
  import Ecto.Changeset
  alias Escrow.Repo

  schema "escrows" do
    field(:item_id, :string)

    timestamps()
  end

  def changeset(listing, params) do
    listing
    |> cast(params, [:item_id])
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end
end
