defmodule Mutually.Vaults.VaultItem do
  alias Mutually.Vaults.Vault

  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id,:file_path, :file_type, :inserted_at]}
  schema "vault_items" do
    field :file_path, :string
    field :file_type, :string
    belongs_to :vault, Vault

    timestamps(type: :utc_datetime)
  end

  def changeset(vault_item, attrs) do
    vault_item
    |> cast(attrs, [:file_path, :file_type])
    |> validate_required([:file_path, :file_type])
  end

  def vault_item_changeset(%Vault{} = vault, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Ecto.Changeset.put_assoc(:vault, vault)
  end
end
