defmodule Mutually.Vaults.Vault do
  alias Mutually.Mutuals.Mutual
  alias Mutually.Vaults.VaultItem
  use Ecto.Schema
  import Ecto.Changeset

  schema "vaults" do
    belongs_to :mutual, Mutual
    has_many :vault_item, VaultItem
    field :locks_at, :utc_datetime
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(vault, attrs) do
    vault
    |> cast(attrs, [:locks_at])
    |> validate_required([])
    |> unique_constraint(:mutual_id)
  end

  def vault_mutual_changeset(%Mutual{} = mutual, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Ecto.Changeset.put_assoc(:mutual, mutual)
  end
end
