defmodule Mutually.Chats.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset

  alias Mutually.Profiles.Profile
  alias Mutually.Chats.Chat

  schema "chat_messages" do
    belongs_to :chat, Chat
    field :content, :string
    field :message_type, :string
    belongs_to :sender, Profile
    field :read, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :message_type])
    |> validate_required([:content, :message_type])
    |> validate_inclusion(:message_type, ~w(audio text image video), message: "Message is not of valid type")
  end

  def chat_message_changeset(%Chat{} = chat, %Profile{} = profile, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Ecto.Changeset.put_assoc(:chat, chat)
    |> Ecto.Changeset.put_assoc(:profile, profile)
  end
end
