defmodule MutuallyWeb.UsersController do
  use MutuallyWeb, :controller

  alias MutuallyWeb.Accounts.Guardian
  alias MutuallyWeb.FallbackController
  alias Mutually.Accounts

  action_fallback MutuallyWeb.FallbackController

  def register(conn, params) do
    case Accounts.create_user(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(FallbackController.translate_errors_to_json(changeset))
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        conn
        |> put_status(:ok)
        |> json(%{user: user, token: token})

      {:error, :no_account} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "No account found with this email"})

      {:error, :invalid_password} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid password"})
    end
  end

  def logout(conn) do
    json(conn, %{})
  end
end
