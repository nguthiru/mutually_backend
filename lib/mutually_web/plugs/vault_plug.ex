defmodule MutuallyWeb.VaultPlug do
  alias Mutually.Vaults.Vault
  alias Mutually.Mutuals.Mutual
  alias Mutually.Vaults
  alias Mutually.Mutuals
  import Plug.Conn
  def init(_opts), do: %{}

  defp is_vault_unlocked(%Vault{} = vault) do
    vault.locks_at < DateTime.utc_now()
  end

  def call(conn, _opts) do
    mutual = conn.assigns.mutual
    %Mutual{vault: vault} = mutual |> Mutuals.preload(:vault)

    case vault do
      nil ->
        with {:ok, vault} <- Vaults.create_vault(mutual) do
          conn
          |> assign(:vault, vault)
        end

      _ ->
        case is_vault_unlocked(vault) do
          true ->
            conn
            |> assign(:vault, vault)

          false ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(403, "Vault is locked")
            |> halt()
        end
    end
  end
end
