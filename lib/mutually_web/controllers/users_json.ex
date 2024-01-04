defmodule MutuallyWeb.UsersJSON do
  alias Mutually.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(users <- users, do: data(users))}
  end

  @doc """
  Renders a single users.
  """
  def show(%{users: users}) do
    %{data: data(users)}
  end

  defp data(%User{} = users) do
    %{
      id: users.id,
      email: users.email,
      hash_password: users.hash_password
    }
  end
end
