defmodule MutuallyWeb.VaultController do
  alias Mutually.Vaults.VaultItem
  alias MutuallyWeb.FallbackController
  alias MutuallyWeb.VaultPlug
  alias MutuallyWeb.Plugs.CheckMutual
  use MutuallyWeb, :controller
  action_fallback MutuallyWeb.FallbackController

  plug CheckMutual
  plug VaultPlug

  def index(conn, _params) do
    vault_items = conn.assigns.vault |> Mutually.VaultItems.list_vault_items()

    conn
    |> json(%{"vault_items" => vault_items})
  end

  def show(conn, %{"vault_item_id" => id}) do
    case Mutually.VaultItems.get_vault_item(conn.assigns.vault, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{"message" => "Vault item not found"})

      vault_item ->
        conn
        |> put_status(:ok)
        |> json(%{"vault_item" => vault_item})
    end
  end

  def create(conn, params) do
    case Mutually.VaultItems.create_vault_item(conn.assigns.vault, params) do
      {:ok, vault_item} ->
        conn
        |> put_status(:ok)
        |> json(%{"message" => "Vault item created", "vault_item" => vault_item})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(FallbackController.translate_errors_to_json(changeset))
    end
  end

  def delete(conn, %{"vault_item_id" => item_id}) do
    case Mutually.VaultItems.get_vault_item(conn.assigns.vault, item_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{"message" => "Vault item not found"})

      %VaultItem{} = vault_item ->
        Mutually.VaultItems.delete_vault_item(vault_item)

        conn
        |> put_status(:ok)
        |> json(%{"message" => "Vault item deleted"})
    end
  end
end
