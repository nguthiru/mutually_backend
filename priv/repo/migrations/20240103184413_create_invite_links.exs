defmodule Mutually.Repo.Migrations.CreateInviteLinks do
  use Ecto.Migration

  def change do
    create table(:invite_links) do
      add :invite_link, :string
      add :profile_id, references(:profiles, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:invite_links, [:profile_id])
  end
end
