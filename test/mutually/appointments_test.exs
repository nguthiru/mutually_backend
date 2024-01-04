defmodule Mutually.AppointmentsTest do
  use Mutually.DataCase

  alias Mutually.Appointments

  describe "appointments" do
    alias Mutually.Appointments.Appointment

    import Mutually.AppointmentsFixtures

    @invalid_attrs %{date: nil, time: nil, location: nil, subject: nil, details: nil}

    test "list_appointments/0 returns all appointments" do
      appointment = appointment_fixture()
      assert Appointments.list_appointments() == [appointment]
    end

    test "get_appointment!/1 returns the appointment with given id" do
      appointment = appointment_fixture()
      assert Appointments.get_appointment!(appointment.id) == appointment
    end

    test "create_appointment/1 with valid data creates a appointment" do
      valid_attrs = %{date: ~D[2024-01-03], time: ~T[14:00:00], location: "some location", subject: "some subject", details: "some details"}

      assert {:ok, %Appointment{} = appointment} = Appointments.create_appointment(valid_attrs)
      assert appointment.date == ~D[2024-01-03]
      assert appointment.time == ~T[14:00:00]
      assert appointment.location == "some location"
      assert appointment.subject == "some subject"
      assert appointment.details == "some details"
    end

    test "create_appointment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Appointments.create_appointment(@invalid_attrs)
    end

    test "update_appointment/2 with valid data updates the appointment" do
      appointment = appointment_fixture()
      update_attrs = %{date: ~D[2024-01-04], time: ~T[15:01:01], location: "some updated location", subject: "some updated subject", details: "some updated details"}

      assert {:ok, %Appointment{} = appointment} = Appointments.update_appointment(appointment, update_attrs)
      assert appointment.date == ~D[2024-01-04]
      assert appointment.time == ~T[15:01:01]
      assert appointment.location == "some updated location"
      assert appointment.subject == "some updated subject"
      assert appointment.details == "some updated details"
    end

    test "update_appointment/2 with invalid data returns error changeset" do
      appointment = appointment_fixture()
      assert {:error, %Ecto.Changeset{}} = Appointments.update_appointment(appointment, @invalid_attrs)
      assert appointment == Appointments.get_appointment!(appointment.id)
    end

    test "delete_appointment/1 deletes the appointment" do
      appointment = appointment_fixture()
      assert {:ok, %Appointment{}} = Appointments.delete_appointment(appointment)
      assert_raise Ecto.NoResultsError, fn -> Appointments.get_appointment!(appointment.id) end
    end

    test "change_appointment/1 returns a appointment changeset" do
      appointment = appointment_fixture()
      assert %Ecto.Changeset{} = Appointments.change_appointment(appointment)
    end
  end
end
