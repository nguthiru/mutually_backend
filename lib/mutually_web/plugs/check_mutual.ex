defmodule MutuallyWeb.Plugs.CheckMutual do
  alias Mutually.Mutuals.Mutual
  alias Mutually.Mutuals
  import Plug.Conn

  def init(_opts), do: %{}

  def call(conn, _opts) do
    # Assuming you store the current user's ID in conn.assigns
    user_profile = conn.assigns.user.profile
    # Assuming mutual_id is provided in the params
    mutual_id = conn.params["id"]

    case Mutuals.get_mutual(mutual_id) do
      %Mutual{} = mutual ->
        case Mutuals.is_profile_in_mutual?(mutual, user_profile) do
          true ->
            conn
            |> assign(:mutual, mutual)

          false ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(403, "Forbidden")
            |> halt()
        end

      nil ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, "Not Found")
        |> halt()
    end
  end
end
