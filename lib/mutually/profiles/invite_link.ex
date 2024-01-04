defmodule Mutually.Profiles.InviteLink do
  alias Mutually.Profiles.Profile
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:invite_link, :profile]}
  schema "invite_links" do
    field :invite_link, :string
    belongs_to :profile, Mutually.Profiles.Profile

    timestamps(type: :utc_datetime)
  end

  @doc false
  def create_link_changeset(%Profile{} = profile, attrs) do
    %__MODULE__{}
    |> cast(attrs, [:invite_link])
    |> validate_required([:invite_link])
    |> unique_constraint(:invite_link)
    |> Ecto.Changeset.put_assoc(:profile, profile)
  end

  def is_within_24_hours?(%__MODULE__{inserted_at: date}) do
    now = DateTime.utc_now()
    twenty_four_hours_from_now = DateTime.add(now, 24, :hour)

    DateTime.diff(twenty_four_hours_from_now, date) > 0
  end
end
