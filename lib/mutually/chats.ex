defmodule Mutually.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias Mutually.Chats.ChatMessage
  alias Mutually.Profiles.Profile
  alias Mutually.Mutuals.Mutual
  alias Mutually.Repo

  alias Mutually.Chats.Chat

  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats do
    Repo.all(Chat)
  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat!(id), do: Repo.get!(Chat, id)

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(%Mutual{} = mutual, attrs \\ %{}) do
    Chat.create_chat_changeset(mutual, attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
  end

  def change_chat(%Chat{} = chat, attrs \\ %{}) do
    Chat.changeset(chat, attrs)
  end

  def create_chat_if_not_exist(%Mutual{id: id} = mutual) do
    chat = Repo.get_by(Chat, mutual_id: id)

    if chat == nil do
      chat = Chat.create_chat_changeset(mutual)
      Repo.insert(chat)
    end

    chat
  end

  def add_chat_message(%Chat{} = chat, %Profile{} = sender, attrs) do
    ChatMessage.chat_message_changeset(chat, sender, attrs)
    |> Repo.insert()
  end

  def get_chat_messages(%Chat{} = chat) do
    query =
      from cm in ChatMessage,
        where: cm.chat_id == ^chat.id,
        order_by: [desc: cm.inserted_at],
        preload: [:sender],
        select: [cm]

    Repo.all(query)
  end
end
