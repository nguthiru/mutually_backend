defmodule Mutually.Repo.Migrations.CreateVaults do
  use Ecto.Migration

  def change do
    create table(:vaults) do
      add :mutual_id, references(:mutuals, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create table(:vault_items) do
      add :vault_id, references(:vaults, on_delete: :nothing)
      add :file_path, :string
      add :file_type, :string
      timestamps(type: :utc_datetime)
    end

    create unique_index(:vaults, [:mutual_id])
  end
end
