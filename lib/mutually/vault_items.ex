defmodule Mutually.VaultItems do
  import Ecto.Query

  alias Mutually.Vaults.VaultItem
  alias Mutually.Vaults.Vault
  alias Mutually.Repo

  def list_vault_items(%Vault{} = vault) do
    query =
      from v in VaultItem,
        where: v.vault_id == ^vault.id,
        select: v

    Repo.all(query)
  end

  def get_vault_item(%Vault{} = vault, item_id) do
    Repo.get_by(VaultItem, id: item_id, vault_id: vault.id)
  end

  def create_vault_item(%Vault{} = vault, attrs) do
    VaultItem.vault_item_changeset(vault, attrs)
    |> Repo.insert()
  end

  def delete_vault_item(%VaultItem{} = vault_item) do
    Repo.delete(vault_item)
  end
end
