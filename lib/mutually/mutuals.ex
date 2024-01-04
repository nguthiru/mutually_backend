defmodule Mutually.Mutuals do
  @moduledoc """
  The Mutuals context.
  """

  import Ecto.Query, warn: false
  alias Mutually.Profiles.Profile
  alias Mutually.Repo

  alias Mutually.Mutuals.Mutual

  @doc """
  Returns the list of mutuals.

  ## Examples

      iex> list_mutuals()
      [%Mutual{}, ...]

  """
  def list_mutuals do
    Repo.all(Mutual)
  end

  @doc """
  Gets a single mutual.

  Raises `Ecto.NoResultsError` if the Mutual does not exist.

  ## Examples

      iex> get_mutual!(123)
      %Mutual{}

      iex> get_mutual!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mutual(id), do: Repo.get(Mutual, id)

  @doc """
  Creates a mutual.

  ## Examples

      iex> create_mutual(%{field: value})
      {:ok, %Mutual{}}

      iex> create_mutual(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mutual(%Profile{} = profile1, %Profile{} = profile2) do
    Mutual.create_friendship_changeset(profile1, profile2)
    |> Repo.insert()
  end

  @doc """
  Updates a mutual.

  ## Examples

      iex> update_mutual(mutual, %{field: new_value})
      {:ok, %Mutual{}}

      iex> update_mutual(mutual, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mutual(%Mutual{} = mutual,attrs \\ %{}) do
    mutual
    |> Mutual.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a mutual.

  ## Examples

      iex> delete_mutual(mutual)
      {:ok, %Mutual{}}

      iex> delete_mutual(mutual)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mutual(%Mutual{} = mutual) do
    Repo.delete(mutual)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mutual changes.

  ## Examples

      iex> change_mutual(mutual)
      %Ecto.Changeset{data: %Mutual{}}

  """

  def change_mutual(%Mutual{} = mutual, attrs \\ %{}) do
    Mutual.changeset(mutual, attrs)
  end

  def get_profile_mutuals(%Profile{} = profile) do
    query =
      from m in Mutual,
        join: p in Profile,
        on: m.profile1_id == p.id or m.profile2_id == p.id,
        where: p.id != ^profile.id,
        select: [m]

    Repo.all(query)
  end

  def are_profile_mutual?(%Profile{} = profile1, %Profile{} = profile2) do
    query =
      from m in Mutual,
        where:
          (m.profile1_id == ^profile1.id and m.profile2_id == ^profile2.id) or
            (m.profile1_id == ^profile2.id and m.profile2_id == ^profile1.id),
        select: true

    case Repo.one(query) do
      nil -> false
      _ -> true
    end
  end

  def is_profile_in_mutual?(%Mutual{} = mutual, %Profile{} = profile) do
    query =
      from m in Mutual,
        where:
          m.id == ^mutual.id and (m.profile1_id == ^profile.id or m.profile2_id == ^profile.id),
        select: true

    case Repo.one(query) do
      nil -> false
      _ -> true
    end
  end

  def remove_mutual(%Mutual{} = mutual, %Profile{} = profile) do
    case is_profile_in_mutual?(mutual, profile) do
      true -> delete_mutual(mutual)
      false -> {:error, :not_allowed}
    end
  end
end
