defmodule MutuallyWeb.VaultPlug do
  alias Mutually.Mutuals.Mutual
  alias Mutually.Vaults
  alias Mutually.Mutuals
  import Plug.Conn
  def init(_opts), do: %{}

  def call(conn, _opts) do
    mutual = conn.assigns.mutual
    %Mutual{vault: vault} = mutual |> Mutuals.preload_vault()

    case vault do
      nil ->
        with {:ok, vault} <- Vaults.create_vault(mutual) do
          conn
          |> assign(:vault, vault)
        end

      _ ->
        conn
        |> assign(:vault, vault)
    end
  end
end
