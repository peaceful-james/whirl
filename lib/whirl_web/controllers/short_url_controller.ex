defmodule WhirlWeb.ShortUrlController do
  use WhirlWeb, :controller

  alias Whirl.Urls
  alias Whirl.Urls.ShortUrl

  def index(conn, %{"short_url" => short_url}) do
    case Urls.get_short_url_by(short_url: short_url) do
      nil -> put_status(conn, 404)
      %ShortUrl{long_url: long_url} -> redirect(conn, external: long_url)
    end
  end
end
