defmodule WhirlWeb.AxisLiveTest do
  use WhirlWeb.ConnCase

  import Phoenix.LiveViewTest
  import Whirl.VarsFixtures

  @create_attrs %{name: "some name", options: ["option1", "option2"], cardinality: 42}
  @update_attrs %{name: "some updated name", options: ["option1"], cardinality: 43}
  @invalid_attrs %{name: nil, options: [], cardinality: nil}

  setup :register_and_log_in_user

  defp create_axis(%{scope: scope}) do
    axis = axis_fixture(scope)

    %{axis: axis}
  end

  describe "Index" do
    setup [:create_axis]

    test "lists all axes", %{conn: conn, axis: axis} do
      {:ok, _index_live, html} = live(conn, ~p"/axes")

      assert html =~ "Listing Axes"
      assert html =~ axis.name
    end

    test "saves new axis", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/axes")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Axis")
               |> render_click()
               |> follow_redirect(conn, ~p"/axes/new")

      assert render(form_live) =~ "New Axis"

      assert form_live
             |> form("#axis-form", axis: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#axis-form", axis: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/axes")

      html = render(index_live)
      assert html =~ "Axis created successfully"
      assert html =~ "some name"
    end

    test "updates axis in listing", %{conn: conn, axis: axis} do
      {:ok, index_live, _html} = live(conn, ~p"/axes")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#axes-#{axis.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/axes/#{axis}/edit")

      assert render(form_live) =~ "Edit Axis"

      assert form_live
             |> form("#axis-form", axis: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#axis-form", axis: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/axes")

      html = render(index_live)
      assert html =~ "Axis updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes axis in listing", %{conn: conn, axis: axis} do
      {:ok, index_live, _html} = live(conn, ~p"/axes")

      assert index_live |> element("#axes-#{axis.id} a", "Delete") |> render_click()
      index_live |> has_element?("#axes-#{axis.id}") |> refute()
    end
  end

  describe "Show" do
    setup [:create_axis]

    test "displays axis", %{conn: conn, axis: axis} do
      {:ok, _show_live, html} = live(conn, ~p"/axes/#{axis}")

      assert html =~ "Show Axis"
      assert html =~ axis.name
    end

    test "updates axis and returns to show", %{conn: conn, axis: axis} do
      {:ok, show_live, _html} = live(conn, ~p"/axes/#{axis}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/axes/#{axis}/edit?return_to=show")

      assert render(form_live) =~ "Edit Axis"

      assert form_live
             |> form("#axis-form", axis: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#axis-form", axis: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/axes/#{axis}")

      html = render(show_live)
      assert html =~ "Axis updated successfully"
      assert html =~ "some updated name"
    end
  end
end
