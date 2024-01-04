defmodule Mutually.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Mutually.Repo

  alias Mutually.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_user()
      [%Users{}, ...]

  """
  def list_user do
    Repo.all(User)
  end

  @doc """
  Gets a single users.

  Raises `Ecto.NoResultsError` if the Users does not exist.

  ## Examples

      iex> get_user!(123)
      %Users{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload(:profile)

  def get_user_by_email(email) do
      User
        |> where(email: ^email)
        |> Repo.one()

  end

  @doc """
  Creates a users.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %Users{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a users.

  ## Examples

      iex> update_user(users, %{field: new_value})
      {:ok, %Users{}}

      iex> update_user(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = users, attrs) do
    users
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a users.

  ## Examples

      iex> delete_user(users)
      {:ok, %Users{}}

      iex> delete_user(users)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = users) do
    Repo.delete(users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking users changes.

  ## Examples

      iex> change_user(users)
      %Ecto.Changeset{data: %Users{}}

  """
  def change_user(%User{} = users, attrs \\ %{}) do
    User.changeset(users, attrs)
  end
end
