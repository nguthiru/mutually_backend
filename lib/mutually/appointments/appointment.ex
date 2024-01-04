defmodule Mutually.Appointments.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appointments" do
    field :date, :date
    field :time, :time
    field :location, :string
    field :subject, :string
    field :details, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(appointment, attrs) do
    appointment
    |> cast(attrs, [:date, :time, :subject, :details, :location])
    |> validate_required([:date, :time, :subject, :details, :location])
  end
end
