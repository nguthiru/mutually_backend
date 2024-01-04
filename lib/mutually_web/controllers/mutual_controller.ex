defmodule MutuallyWeb.MutualController do
  alias MutuallyWeb.Plugs.CheckMutual
  alias MutuallyWeb.FallbackController
  alias Mutually.Mutuals
  use MutuallyWeb, :controller
  action_fallback MutuallyWeb.FallbackController
  plug CheckMutual when action in [:show, :remove_mutual, :update_mutual]

  def index(conn, _params) do
    mutuals = Mutuals.get_profile_mutuals(conn.assigns.user.profile)

    conn
    |> json(%{"mutuals" => mutuals})
  end

  def show(conn, _params) do
    conn
    |> json(conn.assigns.mutual)
  end

  def remove_mutual(conn) do
    conn.assigns.mutual |> Mutuals.delete_mutual()
  end

  def update_mutual(conn, params) do

    case conn.assigns.mutual |> Mutuals.update_mutual(params) do
      {:ok, _} ->
        conn
        |> put_status(:ok)
        |> json(%{"message" => "Mutual updated"})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(FallbackController.translate_errors_to_json(changeset))
    end
  end
end
