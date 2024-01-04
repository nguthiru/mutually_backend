defmodule Mutually.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mutually.Accounts` context.
  """

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{
        email: "some email",
        hash_password: "some hash_password"
      })
      |> Mutually.Accounts.create_users()

    users
  end
end
