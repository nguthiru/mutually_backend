defmodule Mutually.Repo.Migrations.AddMutualPointsTable do
  use Ecto.Migration

  def change do
    create table(:mutual_points) do
      add :mutual_id, references(:mutuals, on_delete: :delete_all)
      add :points, :integer, default: 1


    end

    create unique_index(:mutual_points, :mutual_id)
  end
end
