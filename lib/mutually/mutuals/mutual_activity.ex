defmodule Mutually.Mutuals.MutualActivity do
  alias Mutually.Activities.Activity
  alias Mutually.Mutuals.Mutual
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:activity,:inserted_at]}
  schema "mutual_activities" do
    belongs_to :mutual, Mutually.Mutuals.Mutual
    belongs_to :activity, Mutually.Activities.Activity
    timestamps(type: :utc_datetime)
  end

  def changeset(mutual_activity, attrs) do
    mutual_activity
    |> cast(attrs, [:mutual_id, :activity_id])
    |> validate_required([:mutual_id, :activity_id])
  end

  def mutual_activity_changeset(%Mutual{} = mutual, %Activity{} = activity) do
    %__MODULE__{}
    |> changeset(%{mutual_id: mutual.id, activity_id: activity.id})
    |> Ecto.Changeset.put_assoc(:mutual, mutual)
    |> Ecto.Changeset.put_assoc(:activity, activity)
  end
end
