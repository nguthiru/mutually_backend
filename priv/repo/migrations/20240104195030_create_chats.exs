defmodule Mutually.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :mutual_id, references(:mutuals, on_delete: :delete_all)


      timestamps(type: :utc_datetime)


    end

    create table(:chat_messages) do
      add :chat_id, references(:chats, on_delete: :delete_all)
      add :content, :string
      add :message_type, :string
      add :sender_id, references(:profiles, on_delete: :delete_all)
      add :read, :boolean, default: false
      timestamps(type: :utc_datetime)
    end

    create index(:chats, [:mutual_id])
  end
end
