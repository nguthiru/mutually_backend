defmodule MutuallyWeb.Plugs.ProfilePlug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case authenticate_user(conn) do
      {:ok, user} ->
        conn
        |> assign(:user, user)
        |> assign(:profile, user.profile)

      {:error, _reason} ->
        conn
        |> assign(:user, nil)
    end
  end

  def authenticate_user(conn) do
    case Guardian.Plug.current_resource(conn) do


      {:error, reason} ->
        conn
        |> assign(:user, nil)

        {:error, reason}

        user ->
          {:ok, user}
    end
  end

end
