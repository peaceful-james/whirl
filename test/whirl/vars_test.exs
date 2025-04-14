defmodule Whirl.VarsTest do
  use Whirl.DataCase

  alias Whirl.Vars

  describe "axes" do
    import Whirl.AccountsFixtures, only: [user_scope_fixture: 0]
    import Whirl.VarsFixtures
    alias Whirl.Vars.Axis
    @invalid_attrs %{name: nil, options: nil, cardinality: nil}

    test "list_axes/1 returns all scoped axes" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      axis = axis_fixture(scope)
      other_axis = axis_fixture(other_scope)
      assert Vars.list_axes(scope) == [axis]
      assert Vars.list_axes(other_scope) == [other_axis]
    end

    test "get_axis!/2 returns the axis with given id" do
      scope = user_scope_fixture()
      axis = axis_fixture(scope)
      other_scope = user_scope_fixture()
      assert Vars.get_axis!(scope, axis.id) == axis
      assert_raise Ecto.NoResultsError, fn -> Vars.get_axis!(other_scope, axis.id) end
    end

    test "create_axis/2 with valid data creates a axis" do
      valid_attrs = %{name: "some name", options: ["option1", "option2"], cardinality: 42}
      scope = user_scope_fixture()

      assert {:ok, %Axis{} = axis} = Vars.create_axis(scope, valid_attrs)
      assert axis.name == "some name"
      assert axis.options == ["option1", "option2"]
      assert axis.cardinality == 42
      assert axis.user_id == scope.user.id
    end

    test "create_axis/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Vars.create_axis(scope, @invalid_attrs)
    end

    test "update_axis/3 with valid data updates the axis" do
      scope = user_scope_fixture()
      axis = axis_fixture(scope)
      update_attrs = %{name: "some updated name", options: ["option1"], cardinality: 43}

      assert {:ok, %Axis{} = axis} = Vars.update_axis(scope, axis, update_attrs)
      assert axis.name == "some updated name"
      assert axis.options == ["option1"]
      assert axis.cardinality == 43
    end

    test "update_axis/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      axis = axis_fixture(scope)

      assert_raise MatchError, fn ->
        Vars.update_axis(other_scope, axis, %{})
      end
    end

    test "update_axis/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      axis = axis_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Vars.update_axis(scope, axis, @invalid_attrs)
      assert axis == Vars.get_axis!(scope, axis.id)
    end

    test "delete_axis/2 deletes the axis" do
      scope = user_scope_fixture()
      axis = axis_fixture(scope)
      assert {:ok, %Axis{}} = Vars.delete_axis(scope, axis)
      assert_raise Ecto.NoResultsError, fn -> Vars.get_axis!(scope, axis.id) end
    end

    test "delete_axis/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      axis = axis_fixture(scope)
      assert_raise MatchError, fn -> Vars.delete_axis(other_scope, axis) end
    end

    test "change_axis/2 returns a axis changeset" do
      scope = user_scope_fixture()
      axis = axis_fixture(scope)
      assert %Ecto.Changeset{} = Vars.change_axis(scope, axis)
    end
  end
end
