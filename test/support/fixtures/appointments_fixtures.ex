defmodule Mutually.AppointmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mutually.Appointments` context.
  """

  @doc """
  Generate a appointment.
  """
  def appointment_fixture(attrs \\ %{}) do
    {:ok, appointment} =
      attrs
      |> Enum.into(%{
        date: ~D[2024-01-03],
        details: "some details",
        location: "some location",
        subject: "some subject",
        time: ~T[14:00:00]
      })
      |> Mutually.Appointments.create_appointment()

    appointment
  end
end
