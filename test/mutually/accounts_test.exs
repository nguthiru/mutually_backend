defmodule Mutually.AccountsTest do
  use Mutually.DataCase

  alias Mutually.Accounts

  describe "users" do
    alias Mutually.Accounts.Users

    import Mutually.AccountsFixtures

    @invalid_attrs %{email: nil, hash_password: nil}

    test "list_users/0 returns all users" do
      users = users_fixture()
      assert Accounts.list_users() == [users]
    end

    test "get_users!/1 returns the users with given id" do
      users = users_fixture()
      assert Accounts.get_users!(users.id) == users
    end

    test "create_users/1 with valid data creates a users" do
      valid_attrs = %{email: "some email", hash_password: "some hash_password"}

      assert {:ok, %Users{} = users} = Accounts.create_users(valid_attrs)
      assert users.email == "some email"
      assert users.hash_password == "some hash_password"
    end

    test "create_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_users(@invalid_attrs)
    end

    test "update_users/2 with valid data updates the users" do
      users = users_fixture()
      update_attrs = %{email: "some updated email", hash_password: "some updated hash_password"}

      assert {:ok, %Users{} = users} = Accounts.update_users(users, update_attrs)
      assert users.email == "some updated email"
      assert users.hash_password == "some updated hash_password"
    end

    test "update_users/2 with invalid data returns error changeset" do
      users = users_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_users(users, @invalid_attrs)
      assert users == Accounts.get_users!(users.id)
    end

    test "delete_users/1 deletes the users" do
      users = users_fixture()
      assert {:ok, %Users{}} = Accounts.delete_users(users)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_users!(users.id) end
    end

    test "change_users/1 returns a users changeset" do
      users = users_fixture()
      assert %Ecto.Changeset{} = Accounts.change_users(users)
    end
  end
end
