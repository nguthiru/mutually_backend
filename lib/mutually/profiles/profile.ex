defmodule Mutually.Profiles.Profile do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:full_name, :bio, :id,]}
  schema "profiles" do
    field :full_name, :string
    field :bio, :string
    belongs_to :user, Mutually.Accounts.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:full_name, :bio])
    |> validate_required([:full_name])
    |> unique_constraint(:user_id)
  end

  def create_profile_changeset(user, attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
  end
end
