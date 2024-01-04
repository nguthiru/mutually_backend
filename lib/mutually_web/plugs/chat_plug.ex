defmodule MutuallyWeb.ChatPlug do
  alias Mutually.Chats
  alias Mutually.Mutuals.Mutual
  alias Mutually.Mutuals
  import Plug.Conn

  def init(_opts), do: %{}

  def call(conn, _opts) do
    mutual = conn.assigns.mutual
    %Mutual{chat: chat} = mutual |> Mutuals.preload(:chat)

    case chat do
      nil ->
        with {:ok, chat} <- Chats.create_chat(mutual) do
          conn
          |> assign(:chat, chat)
        end

      _ ->
        conn
        |> assign(:chat, chat)
    end
  end
end
