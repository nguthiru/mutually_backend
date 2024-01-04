defmodule MutuallyWeb.ChatController do
  alias Mutually.Chats
  alias MutuallyWeb.ChatPlug
  alias MutuallyWeb.Plugs.CheckMutual
  use MutuallyWeb, :controller
  action_fallback MutuallyWeb.FallbackController

  plug CheckMutual
  plug ChatPlug

  def chat_messages(conn, _params) do
    chat = conn.assigns.chat
    messages = chat |> Chats.get_chat_messages()

    conn
    |> json(messages)
  end
end
