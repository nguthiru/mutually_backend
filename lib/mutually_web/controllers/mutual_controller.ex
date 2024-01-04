defmodule MutuallyWeb.MutualController do
  alias MutuallyWeb.FallbackController
  alias Mutually.Mutuals.Mutual
  alias Mutually.Mutuals
  use MutuallyWeb, :controller
  action_fallback MutuallyWeb.FallbackController

  def index(conn, _params) do
    mutuals = Mutuals.get_profile_mutuals(conn.assigns.user.profile)

    conn
    |> json(%{"mutuals" => mutuals})
  end

  def show(conn, %{"id" => id}) do
    user_profile = conn.assigns.user.profile
    mutual = Mutuals.get_mutual(id)

    case mutual do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{"error" => "Not Found"})

      %Mutual{} = mutual ->
        case mutual |> Mutuals.is_profile_in_mutual?(user_profile) do
          true ->
            conn
            |> json(%{"mutual" => mutual})

          false ->
            conn
            |> put_status(:forbidden)
            |> json(%{"error" => "Not Allowed"})
        end
    end
  end

  def remove_mutual(conn, %{"id" => id}) do
    user_profile = conn.assigns.user.profile

    case Mutuals.get_mutual(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{"error" => "Not Found"})

      %Mutual{} = mutual ->
        case mutual |> Mutuals.remove_mutual(user_profile) do
          {:ok, _} ->
            conn
            |> put_status(:ok)
            |> json(%{"message" => "Mutual removed"})

          {:error, :not_allowed} ->
            conn
            |> put_status(:forbidden)
            |> json(%{"error" => "Not Allowed"})

          {:error, _} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{"error" => "Internal Server Error"})
        end
    end
  end

  def update_mutual(conn, %{"id" => id} = params) do
    user_profile = conn.assigns.user.profile

    case Mutuals.get_mutual(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{"error" => "Not Found"})

      %Mutual{} = mutual ->
        case mutual |> Mutuals.update_mutual(user_profile, params) do
          {:ok, _} ->
            conn
            |> put_status(:ok)
            |> json(%{"message" => "Mutual updated"})

          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(:bad_request)
            |> json(FallbackController.translate_errors_to_json(changeset))

          {:error, :not_allowed} ->
            conn
            |> put_status(:forbidden)
            |> json(%{"error" => "Not Allowed"})
        end
    end
  end
end
