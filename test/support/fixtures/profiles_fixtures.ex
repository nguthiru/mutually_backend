defmodule Mutually.ProfilesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mutually.Profiles` context.
  """

  @doc """
  Generate a profile.
  """
  def profile_fixture(attrs \\ %{}) do
    {:ok, profile} =
      attrs
      |> Enum.into(%{
        bio: "some bio",
        full_name: "some full_name"
      })
      |> Mutually.Profiles.create_profile()

    profile
  end
end
