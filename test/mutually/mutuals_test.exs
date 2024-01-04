defmodule Mutually.MutualsTest do
  use Mutually.DataCase

  alias Mutually.Mutuals

  describe "mutuals" do
    alias Mutually.Mutuals.Mutual

    import Mutually.MutualsFixtures

    @invalid_attrs %{}

    test "list_mutuals/0 returns all mutuals" do
      mutual = mutual_fixture()
      assert Mutuals.list_mutuals() == [mutual]
    end

    test "get_mutual!/1 returns the mutual with given id" do
      mutual = mutual_fixture()
      assert Mutuals.get_mutual!(mutual.id) == mutual
    end

    test "create_mutual/1 with valid data creates a mutual" do
      valid_attrs = %{}

      assert {:ok, %Mutual{} = mutual} = Mutuals.create_mutual(valid_attrs)
    end

    test "create_mutual/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mutuals.create_mutual(@invalid_attrs)
    end

    test "update_mutual/2 with valid data updates the mutual" do
      mutual = mutual_fixture()
      update_attrs = %{}

      assert {:ok, %Mutual{} = mutual} = Mutuals.update_mutual(mutual, update_attrs)
    end

    test "update_mutual/2 with invalid data returns error changeset" do
      mutual = mutual_fixture()
      assert {:error, %Ecto.Changeset{}} = Mutuals.update_mutual(mutual, @invalid_attrs)
      assert mutual == Mutuals.get_mutual!(mutual.id)
    end

    test "delete_mutual/1 deletes the mutual" do
      mutual = mutual_fixture()
      assert {:ok, %Mutual{}} = Mutuals.delete_mutual(mutual)
      assert_raise Ecto.NoResultsError, fn -> Mutuals.get_mutual!(mutual.id) end
    end

    test "change_mutual/1 returns a mutual changeset" do
      mutual = mutual_fixture()
      assert %Ecto.Changeset{} = Mutuals.change_mutual(mutual)
    end
  end
end
