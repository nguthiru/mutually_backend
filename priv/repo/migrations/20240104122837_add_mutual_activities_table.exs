defmodule Mutually.Repo.Migrations.AddMutualActivitiesTable do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :name, :string
      add :icon, :string
      add :tag, :string, null: false

      add :points, :integer, default: 1
      timestamps()
    end

    create table(:mutual_activities) do
      add :mutual_id, references(:mutuals, on_delete: :delete_all)
      add :activity_id, references(:activities, on_delete: :delete_all)
      timestamps()
    end
  end
end
