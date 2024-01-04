defmodule Mutually.Chats.Chat do
  alias Mutually.Mutuals.Mutual
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    belongs_to :mutual, Mutual
    has_many :messages, Mutually.Chats.ChatMessage

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [])
    |> validate_required([])
  end

  def create_chat_changeset(%Mutual{} = mutual, attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Ecto.Changeset.put_assoc(:mutual, mutual)
  end
end
