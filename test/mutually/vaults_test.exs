defmodule Mutually.VaultsTest do
  use Mutually.DataCase

  alias Mutually.Vaults

  describe "vaults" do
    alias Mutually.Vaults.Vault

    import Mutually.VaultsFixtures

    @invalid_attrs %{}

    test "list_vaults/0 returns all vaults" do
      vault = vault_fixture()
      assert Vaults.list_vaults() == [vault]
    end

    test "get_vault!/1 returns the vault with given id" do
      vault = vault_fixture()
      assert Vaults.get_vault!(vault.id) == vault
    end

    test "create_vault/1 with valid data creates a vault" do
      valid_attrs = %{}

      assert {:ok, %Vault{} = vault} = Vaults.create_vault(valid_attrs)
    end

    test "create_vault/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vaults.create_vault(@invalid_attrs)
    end

    test "update_vault/2 with valid data updates the vault" do
      vault = vault_fixture()
      update_attrs = %{}

      assert {:ok, %Vault{} = vault} = Vaults.update_vault(vault, update_attrs)
    end

    test "update_vault/2 with invalid data returns error changeset" do
      vault = vault_fixture()
      assert {:error, %Ecto.Changeset{}} = Vaults.update_vault(vault, @invalid_attrs)
      assert vault == Vaults.get_vault!(vault.id)
    end

    test "delete_vault/1 deletes the vault" do
      vault = vault_fixture()
      assert {:ok, %Vault{}} = Vaults.delete_vault(vault)
      assert_raise Ecto.NoResultsError, fn -> Vaults.get_vault!(vault.id) end
    end

    test "change_vault/1 returns a vault changeset" do
      vault = vault_fixture()
      assert %Ecto.Changeset{} = Vaults.change_vault(vault)
    end
  end
end
