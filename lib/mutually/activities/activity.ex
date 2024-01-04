defmodule Mutually.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:name, :tag, :icon]}
  schema "activities" do
    field :name, :string
    field :tag, :string
    field :icon, :string
    field :points, :integer
    timestamps()
  end

  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:tag, :name, :icon, :points])
    |> validate_required([:tag, :name])
  end
end
