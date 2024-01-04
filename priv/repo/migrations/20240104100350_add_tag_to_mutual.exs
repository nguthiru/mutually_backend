defmodule Mutually.Repo.Migrations.AddTagToMutual do
  use Ecto.Migration

  def change do
    alter table(:mutuals) do
      add :tag, :string, default: "S"
    end
  end
end
