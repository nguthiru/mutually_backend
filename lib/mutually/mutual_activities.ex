defmodule Mutually.MutualActivities do
  alias Mutually.Mutuals.MutualPoints
  alias Mutually.Repo
  alias Mutually.Mutuals.MutualActivity
  alias Mutually.Mutuals.Mutual
  alias Mutually.Activities.Activity
  import Ecto.Query

  def post_create({:ok, %MutualActivity{} = mutual_activity}) do
    add_mutual_points(mutual_activity)
    {:ok, mutual_activity}
  end

  def create_mutual_activity(%Mutual{} = mutual, %Activity{} = activity) do
    MutualActivity.mutual_activity_changeset(mutual, activity)
    |> Repo.insert()
    |> post_create()
  end

  def get_mutual_activities(%Mutual{} = mutual) do
    query =
      from m in MutualActivity,
        where: m.mutual_id == ^mutual.id,
        select: m

    Repo.all(query) |> Repo.preload(:activity)
  end

  defp update_mutual_points(%MutualPoints{points: points} = mutual_points, %Activity{
         points: activity_points
       }) do
    total_points = points + activity_points
    IO.inspect(total_points)

    mutual_points
    |> MutualPoints.changeset(%{points: total_points})
    |> Repo.update!()
  end

  defp add_mutual_points(%MutualActivity{} = mutualActivity) do
    activity = Repo.get(Activity, mutualActivity.activity_id)

    case Repo.get_by(MutualPoints, mutual_id: mutualActivity.mutual_id) do
      nil ->
        MutualPoints.mutual_points_changeset(mutualActivity.mutual)
        |> Repo.insert()

      mutualPoints ->
        update_mutual_points(mutualPoints, activity)
    end
  end
end
