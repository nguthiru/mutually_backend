defmodule Mutually.Repo.Migrations.CreateAppointments do
  use Ecto.Migration

  def change do
    create table(:appointments) do
      add :date, :date
      add :time, :time
      add :subject, :string
      add :details, :string
      add :location, :string

      timestamps(type: :utc_datetime)
    end
  end
end
