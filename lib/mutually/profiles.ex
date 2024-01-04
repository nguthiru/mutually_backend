defmodule Mutually.Profiles do
  @moduledoc """
  The Profiles context.
  """

  import Ecto.Query, warn: false
  alias Mutually.Profiles.InviteLink
  alias Mutually.Repo

  alias Mutually.Profiles.Profile
  alias Mutually.Accounts.User

  @doc """
  Returns the list of profiles.

  ## Examples

      iex> list_profiles()
      [%Profile{}, ...]

  """
  def list_profiles do
    Repo.all(Profile)
  end

  @doc """
  Gets a single profile.

  Raises `Ecto.NoResultsError` if the Profile does not exist.

  ## Examples

      iex> get_profile!(123)
      %Profile{}

      iex> get_profile!(456)
      ** (Ecto.NoResultsError)

  """
  def get_profile(id), do: Repo.get(Profile, id)

  def get_profile_from_user(%User{id: user_id}) do
    Profile
    |> where(user_id: ^user_id)
    |> Repo.one()
  end

  @doc """
  Creates a profile.

  ## Examples

      iex> create_profile(%{field: value})
      {:ok, %Profile{}}

      iex> create_profile(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_profile(%User{} = user, attrs \\ %{}) do
    Profile.create_profile_changeset(user, attrs)
    |> Repo.insert()

    # profile|> Repo.insert!()
  end

  @doc """
  Updates a profile.

  ## Examples

      iex> update_profile(profile, %{field: new_value})
      {:ok, %Profile{}}

      iex> update_profile(profile, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_profile(%Profile{} = profile, attrs) do
    profile
    |> Profile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a profile.

  ## Examples

      iex> delete_profile(profile)
      {:ok, %Profile{}}

      iex> delete_profile(profile)
      {:error, %Ecto.Changeset{}}

  """
  def delete_profile(%Profile{} = profile) do
    Repo.delete(profile)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking profile changes.

  ## Examples

      iex> change_profile(profile)
      %Ecto.Changeset{data: %Profile{}}

  """
  def change_profile(%Profile{} = profile, attrs \\ %{}) do
    Profile.changeset(profile, attrs)
  end

  def generate_profile_link(%Profile{} = profile) do
    # generate a random string

    random_string = :crypto.strong_rand_bytes(9) |> Base.encode64()

    InviteLink.create_link_changeset(profile, %{"invite_link" => random_string})
    |> Repo.insert()
  end

  def get_invite_link(invite_link) do
    InviteLink |> Repo.get_by(invite_link: invite_link) |> Repo.preload(:profile)
  end

  def delete_invite_link(%InviteLink{}=invite_link) do
    invite_link |> Repo.delete()

  end

  # def generate_profile_link(%Profile{id: id}) do
  #   ## TODO: START From supervisor

  # end

  # def accept_profile_invite(%Profile{}=user_profile,invite_link) do

  # end

  # defp make_friends(_profile1,_profile2) do
  #     {:ok}
  # end
end
