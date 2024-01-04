defmodule MutuallyWeb.AppointmentController do
  alias MutuallyWeb.FallbackController
  alias Mutually.Appointments
  alias MutuallyWeb.Plugs.CheckMutual
  use MutuallyWeb, :controller
  action_fallback MutuallyWeb.FallbackController

  plug CheckMutual

  def mutual_appointments(conn, _params) do
    appointments = Appointments.get_mutual_appointments(conn.assigns.mutual)

    conn
    |> json(%{"appointments" => appointments})
  end

  def show_mutual_appointments(conn,%{"appointment_id"=>id}) do
    mutual = conn.assigns.mutual
    case Appointments.get_appointment(mutual, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{"message" => "Appointment not found"})

      appointment ->
        conn
        |> put_status(:ok)
        |> json(%{"appointment" => appointment})
    end
  end

  def create(conn, params) do
    mutual = conn.assigns.mutual

    case Appointments.create_appointment(mutual, params) do
      {:ok, appointment} ->
        conn
        |> put_status(:ok)
        |> json(%{"message" => "Appointment created", "appointment" => appointment})

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(FallbackController.translate_errors_to_json(changeset))
    end
  end

  def update(conn, %{"appointment_id" => id} = params) do
    mutual = conn.assigns.mutual

    case Appointments.get_appointment(mutual, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{"message" => "Appointment not found"})

      appointment ->
        Appointments.update_appointment(appointment, params)

        conn
        |> put_status(:ok)
        |> json(%{"message" => "Appointment updated", "appointment" => appointment})
    end
  end

  def delete(conn, %{"appointment_id" => id}) do
    mutual = conn.assigns.mutual

    case Appointments.get_appointment(mutual, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{"message" => "Appointment not found"})

      appointment ->
        Appointments.delete_appointment(appointment)

        conn
        |> put_status(:ok)
        |> json(%{"message" => "Appointment deleted"})
    end
  end
end
