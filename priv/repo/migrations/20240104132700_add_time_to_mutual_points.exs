defmodule Mutually.Repo.Migrations.AddTimeToMutualPoints do
  use Ecto.Migration

  def change do
    alter table(:mutual_points) do
      timestamps()
    end
  end
end
