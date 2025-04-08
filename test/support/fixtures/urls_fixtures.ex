defmodule Whirl.UrlsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Whirl.Urls` context.
  """

  @doc """
  Generate a short_url.
  """
  def short_url_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        long_url: "some long_url",
        short_url: "some short_url"
      })

    {:ok, short_url} = Whirl.Urls.create_short_url(scope, attrs)
    short_url
  end
end
