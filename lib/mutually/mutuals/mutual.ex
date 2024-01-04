defmodule Mutually.Mutuals.Mutual do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mutually.Appointments.Appointment
  alias Mutually.Profiles.Profile

  @derive {Jason.Encoder, only: [:id, :profile1_id, :profile2_id, :tag]}
  schema "mutuals" do
    belongs_to :profile1, Profile
    belongs_to :profile2, Profile
    field :tag, :string

    has_many :appointment, Appointment
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(mutual, attrs) do
    mutual
    |> cast(attrs, [:tag])
    |> validate_required([])
    |> validate_inclusion(:tag, ~w(F BFF L S), message: "Must be within allowed values")
    |> unique_constraint([:profile1, :profile2])
  end

  def create_friendship_changeset(%Profile{} = profile1, %Profile{} = profile2, attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Ecto.Changeset.put_assoc(:profile1, profile1)
    |> Ecto.Changeset.put_assoc(:profile2, profile2)
  end
end
