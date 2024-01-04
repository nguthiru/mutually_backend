defmodule Mutually.Appointments.Appointment do
  alias Mutually.Mutuals.Mutual
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:id, :date, :time, :location, :subject, :details, :mutual_id ]}
  schema "appointments" do
    field :date, :date
    field :time, :time
    field :location, :string
    field :subject, :string
    field :details, :string

    belongs_to :mutual, Mutual

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(appointment, attrs) do
    appointment
    |> cast(attrs, [:date, :time, :subject, :details, :location])
    |> validate_required([:date, :time, :subject])
  end

  def appointment_changeset(%Mutual{} = mutual, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Ecto.Changeset.put_assoc(:mutual, mutual)
  end
end
