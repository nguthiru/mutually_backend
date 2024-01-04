defmodule MutuallyWeb.ProfileControllerTest do
  use MutuallyWeb.ConnCase

  import Mutually.ProfilesFixtures

  alias Mutually.Profiles.Profile

  @create_attrs %{
    full_name: "some full_name",
    bio: "some bio"
  }
  @update_attrs %{
    full_name: "some updated full_name",
    bio: "some updated bio"
  }
  @invalid_attrs %{full_name: nil, bio: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all profiles", %{conn: conn} do
      conn = get(conn, ~p"/api/profiles")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create profile" do
    test "renders profile when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/profiles", profile: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/profiles/#{id}")

      assert %{
               "id" => ^id,
               "bio" => "some bio",
               "full_name" => "some full_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/profiles", profile: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update profile" do
    setup [:create_profile]

    test "renders profile when data is valid", %{conn: conn, profile: %Profile{id: id} = profile} do
      conn = put(conn, ~p"/api/profiles/#{profile}", profile: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/profiles/#{id}")

      assert %{
               "id" => ^id,
               "bio" => "some updated bio",
               "full_name" => "some updated full_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, profile: profile} do
      conn = put(conn, ~p"/api/profiles/#{profile}", profile: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete profile" do
    setup [:create_profile]

    test "deletes chosen profile", %{conn: conn, profile: profile} do
      conn = delete(conn, ~p"/api/profiles/#{profile}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/profiles/#{profile}")
      end
    end
  end

  defp create_profile(_) do
    profile = profile_fixture()
    %{profile: profile}
  end
end
