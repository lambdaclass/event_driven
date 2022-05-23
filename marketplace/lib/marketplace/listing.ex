defmodule Marketplace.Listing do
  use Ecto.Schema
  import Ecto.Changeset
  alias Marketplace.Repo
  import Ecto.Query

  schema "listings" do
    field(:status, :string)
    field(:item_id, :string)

    timestamps()
  end

  def changeset(listing, params) do
    listing
    |> cast(params, [:status, :item_id])
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def set_as_published(item_id) do
    from(l in __MODULE__, where: l.item_id == ^item_id)
    |> Repo.one()
    |> changeset(%{status: "published"})
    |> Repo.update()
  end
end
