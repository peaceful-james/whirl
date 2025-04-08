defmodule Whirl.UrlsTest do
  use Whirl.DataCase

  alias Whirl.Urls

  describe "short_url" do
    alias Whirl.Urls.ShortUrl

    import Whirl.AccountsFixtures, only: [user_scope_fixture: 0]
    import Whirl.UrlsFixtures

    @invalid_attrs %{long_url: nil, short_url: nil}

    test "list_short_url/1 returns all scoped short_url" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      short_url = short_url_fixture(scope)
      other_short_url = short_url_fixture(other_scope)
      assert Urls.list_short_url(scope) == [short_url]
      assert Urls.list_short_url(other_scope) == [other_short_url]
    end

    test "get_short_url!/2 returns the short_url with given id" do
      scope = user_scope_fixture()
      short_url = short_url_fixture(scope)
      other_scope = user_scope_fixture()
      assert Urls.get_short_url!(scope, short_url.id) == short_url
      assert_raise Ecto.NoResultsError, fn -> Urls.get_short_url!(other_scope, short_url.id) end
    end

    test "create_short_url/2 with valid data creates a short_url" do
      valid_attrs = %{long_url: "some long_url", short_url: "some short_url"}
      scope = user_scope_fixture()

      assert {:ok, %ShortUrl{} = short_url} = Urls.create_short_url(scope, valid_attrs)
      assert short_url.long_url == "some long_url"
      assert short_url.short_url == "some short_url"
      assert short_url.user_id == scope.user.id
    end

    test "create_short_url/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Urls.create_short_url(scope, @invalid_attrs)
    end

    test "update_short_url/3 with valid data updates the short_url" do
      scope = user_scope_fixture()
      short_url = short_url_fixture(scope)
      update_attrs = %{long_url: "some updated long_url", short_url: "some updated short_url"}

      assert {:ok, %ShortUrl{} = short_url} = Urls.update_short_url(scope, short_url, update_attrs)
      assert short_url.long_url == "some updated long_url"
      assert short_url.short_url == "some updated short_url"
    end

    test "update_short_url/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      short_url = short_url_fixture(scope)

      assert_raise MatchError, fn ->
        Urls.update_short_url(other_scope, short_url, %{})
      end
    end

    test "update_short_url/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      short_url = short_url_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Urls.update_short_url(scope, short_url, @invalid_attrs)
      assert short_url == Urls.get_short_url!(scope, short_url.id)
    end

    test "delete_short_url/2 deletes the short_url" do
      scope = user_scope_fixture()
      short_url = short_url_fixture(scope)
      assert {:ok, %ShortUrl{}} = Urls.delete_short_url(scope, short_url)
      assert_raise Ecto.NoResultsError, fn -> Urls.get_short_url!(scope, short_url.id) end
    end

    test "delete_short_url/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      short_url = short_url_fixture(scope)
      assert_raise MatchError, fn -> Urls.delete_short_url(other_scope, short_url) end
    end

    test "change_short_url/2 returns a short_url changeset" do
      scope = user_scope_fixture()
      short_url = short_url_fixture(scope)
      assert %Ecto.Changeset{} = Urls.change_short_url(scope, short_url)
    end
  end
end
