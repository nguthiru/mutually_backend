defmodule Mutually.Repo.Migrations.CreateMutuals do
  use Ecto.Migration

  def change do
    create table(:mutuals) do
      add :profile1_id, references(:profiles, on_delete: :delete_all)
      add :profile2_id, references(:profiles, on_delete: :delete_all)

      timestamps(type: :utc_datetime)

    end
    create unique_index(:mutuals, [:profile1_id, :profile2_id])
  end
end
