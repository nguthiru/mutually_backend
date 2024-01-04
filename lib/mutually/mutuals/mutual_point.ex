defmodule Mutually.Mutuals.MutualPoints do
  alias Mutually.Mutuals.Mutual
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:mutual_id, :points]}
  schema "mutual_points" do
    belongs_to :mutual, Mutual
    field :points, :integer
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(mutual, attrs) do
    mutual
    |> cast(attrs, [:points])
    |> validate_required([])
    |> unique_constraint(:mutual_id)
  end

  def mutual_points_changeset(%Mutual{} = mutual, attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Ecto.Changeset.put_assoc(:mutual, mutual)
  end
end
