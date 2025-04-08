defmodule WhirlWeb.ShortUrlLiveTest do
  use WhirlWeb.ConnCase

  import Phoenix.LiveViewTest
  import Whirl.UrlsFixtures

  @create_attrs %{long_url: "some long_url", short_url: "some short_url"}
  @update_attrs %{long_url: "some updated long_url", short_url: "some updated short_url"}
  @invalid_attrs %{long_url: nil, short_url: nil}

  setup :register_and_log_in_user

  defp create_short_url(%{scope: scope}) do
    short_url = short_url_fixture(scope)

    %{short_url: short_url}
  end

  describe "Index" do
    setup [:create_short_url]

    test "lists all short_url", %{conn: conn, short_url: short_url} do
      {:ok, _index_live, html} = live(conn, ~p"/short_url")

      assert html =~ "Listing Short url"
      assert html =~ short_url.long_url
    end

    test "saves new short_url", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/short_url")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Short url")
               |> render_click()
               |> follow_redirect(conn, ~p"/short_url/new")

      assert render(form_live) =~ "New Short url"

      assert form_live
             |> form("#short_url-form", short_url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#short_url-form", short_url: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/short_url")

      html = render(index_live)
      assert html =~ "Short url created successfully"
      assert html =~ "some long_url"
    end

    test "updates short_url in listing", %{conn: conn, short_url: short_url} do
      {:ok, index_live, _html} = live(conn, ~p"/short_url")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#short_url-#{short_url.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/short_url/#{short_url}/edit")

      assert render(form_live) =~ "Edit Short url"

      assert form_live
             |> form("#short_url-form", short_url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#short_url-form", short_url: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/short_url")

      html = render(index_live)
      assert html =~ "Short url updated successfully"
      assert html =~ "some updated long_url"
    end

    test "deletes short_url in listing", %{conn: conn, short_url: short_url} do
      {:ok, index_live, _html} = live(conn, ~p"/short_url")

      assert index_live |> element("#short_url-#{short_url.id} a", "Delete") |> render_click()
      index_live |> has_element?("#short_url-#{short_url.id}") |> refute()
    end
  end

  describe "Show" do
    setup [:create_short_url]

    test "displays short_url", %{conn: conn, short_url: short_url} do
      {:ok, _show_live, html} = live(conn, ~p"/short_url/#{short_url}")

      assert html =~ "Show Short url"
      assert html =~ short_url.long_url
    end

    test "updates short_url and returns to show", %{conn: conn, short_url: short_url} do
      {:ok, show_live, _html} = live(conn, ~p"/short_url/#{short_url}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/short_url/#{short_url}/edit?return_to=show")

      assert render(form_live) =~ "Edit Short url"

      assert form_live
             |> form("#short_url-form", short_url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#short_url-form", short_url: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/short_url/#{short_url}")

      html = render(show_live)
      assert html =~ "Short url updated successfully"
      assert html =~ "some updated long_url"
    end
  end
end
