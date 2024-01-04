defmodule Mutually.Appointments do
  @moduledoc """
  The Appointments context.
  """

  import Ecto.Query, warn: false
  alias Mutually.Activities.Activity
  alias Mutually.MutualActivities
  alias Mutually.Activities
  alias Mutually.Mutuals.Mutual
  alias Mutually.Repo

  alias Mutually.Appointments.Appointment

  @doc """
  Returns the list of appointments.

  ## Examples

      iex> list_appointments()
      [%Appointment{}, ...]

  """
  def list_appointments do
    Repo.all(Appointment)
  end

  @doc """
  Gets a single appointment.

  Raises `Ecto.NoResultsError` if the Appointment does not exist.

  ## Examples

      iex> get_appointment!(123)
      %Appointment{}

      iex> get_appointment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_appointment(%Mutual{} = mutual, id) do
    query =
      from a in Appointment,
        where: a.id == ^id and a.mutual_id == ^mutual.id,
        select: a

    Repo.one!(query) |> Repo.preload(:mutual)
  end

  def get_appointment(id), do: Repo.get(Appointment, id)

  defp post_create({:ok, %Appointment{} = appointment}) do
    appointment |> register_appointment_activity()
    {:ok, appointment}
  end

  defp post_create(_) do
  end

  def create_appointment(%Mutual{} = mutual, attrs \\ %{}) do
    mutual
    |> Appointment.appointment_changeset(attrs)
    |> Repo.insert()
    |> post_create()
  end

  defp register_appointment_activity(%Appointment{} = appointment) do
    appointment = Repo.preload(appointment, :mutual)

    case Activities.get_activity("A") do
      %Activity{} = activity ->
        MutualActivities.create_mutual_activity(appointment.mutual, activity)

      nil ->
        {:ok,activity} = Activities.create_activity(%{tag: "A", name: "Appointment"})
        MutualActivities.create_mutual_activity(appointment.mutual, activity)
    end
  end

  @doc """
  Updates a appointment.

  ## Examples

      iex> update_appointment(appointment, %{field: new_value})
      {:ok, %Appointment{}}

      iex> update_appointment(appointment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_appointment(%Appointment{} = appointment, attrs) do
    appointment
    |> Appointment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a appointment.

  ## Examples

      iex> delete_appointment(appointment)
      {:ok, %Appointment{}}

      iex> delete_appointment(appointment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_appointment(%Appointment{} = appointment) do
    Repo.delete(appointment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking appointment changes.

  ## Examples

      iex> change_appointment(appointment)
      %Ecto.Changeset{data: %Appointment{}}

  """
  def change_appointment(%Appointment{} = appointment, attrs \\ %{}) do
    Appointment.changeset(appointment, attrs)
  end

  def get_mutual_appointments(%Mutual{} = mutual) do
    query =
      from a in Appointment,
        where: a.mutual_id == ^mutual.id,
        select: a

    Repo.all(query) |> Repo.preload(:mutual)
  end
end
