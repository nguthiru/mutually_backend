defmodule Mutually.VaultsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mutually.Vaults` context.
  """

  @doc """
  Generate a vault.
  """
  def vault_fixture(attrs \\ %{}) do
    {:ok, vault} =
      attrs
      |> Enum.into(%{

      })
      |> Mutually.Vaults.create_vault()

    vault
  end
end
