defmodule Mutually.Activities do
  alias Mutually.Activities.Activity
  alias Mutually.Repo
  import Ecto.Query, warn: false

  def get_activity(tag), do: Activity |> Repo.get_by(tag: tag)

  def list_activities do
    Repo.all(Activity)
  end

  def create_activity(attrs) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()

  end
end
