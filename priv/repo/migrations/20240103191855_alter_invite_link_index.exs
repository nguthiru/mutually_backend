defmodule Mutually.Repo.Migrations.AlterInviteLinkIndex do
  use Ecto.Migration

  def change do

    create unique_index(:invite_links, [:invite_link])
  end
end
