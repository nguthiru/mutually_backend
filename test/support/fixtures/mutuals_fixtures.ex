defmodule Mutually.MutualsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mutually.Mutuals` context.
  """

  @doc """
  Generate a mutual.
  """
  def mutual_fixture(attrs \\ %{}) do
    {:ok, mutual} =
      attrs
      |> Enum.into(%{

      })
      |> Mutually.Mutuals.create_mutual()

    mutual
  end
end
