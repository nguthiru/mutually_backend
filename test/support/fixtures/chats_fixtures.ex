defmodule Mutually.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mutually.Chats` context.
  """

  @doc """
  Generate a chat.
  """
  def chat_fixture(attrs \\ %{}) do
    {:ok, chat} =
      attrs
      |> Enum.into(%{

      })
      |> Mutually.Chats.create_chat()

    chat
  end
end
