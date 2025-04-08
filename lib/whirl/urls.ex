defmodule Whirl.Urls do
  @moduledoc """
  The Urls context.
  """

  import Ecto.Query, warn: false

  alias Whirl.Accounts.Scope
  alias Whirl.Repo
  alias Whirl.Urls.ShortUrl

  @doc """
  Subscribes to scoped notifications about any short_url changes.

  The broadcasted messages match the pattern:

    * {:created, %ShortUrl{}}
    * {:updated, %ShortUrl{}}
    * {:deleted, %ShortUrl{}}

  """
  def subscribe_short_url(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Whirl.PubSub, "user:#{key}:short_url")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Whirl.PubSub, "user:#{key}:short_url", message)
  end

  @doc """
  Returns the list of short_url.

  ## Examples

      iex> list_short_url(scope)
      [%ShortUrl{}, ...]

  """
  def list_short_url(%Scope{} = scope) do
    Repo.all(from short_url in ShortUrl, where: short_url.user_id == ^scope.user.id)
  end

  @doc """
  Gets a single short_url.

  Raises `Ecto.NoResultsError` if the Short url does not exist.

  ## Examples

      iex> get_short_url!(123)
      %ShortUrl{}

      iex> get_short_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_short_url!(%Scope{} = scope, id) do
    Repo.get_by!(ShortUrl, id: id, user_id: scope.user.id)
  end

  def get_short_url_by(get_by) do
    Repo.get_by(ShortUrl, get_by)
  end

  @doc """
  Creates a short_url.

  ## Examples

      iex> create_short_url(%{field: value})
      {:ok, %ShortUrl{}}

      iex> create_short_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_short_url(%Scope{} = scope, attrs \\ %{}) do
    with {:ok, %ShortUrl{} = short_url} <-
           %ShortUrl{}
           |> ShortUrl.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, short_url})
      {:ok, short_url}
    end
  end

  @doc """
  Updates a short_url.

  ## Examples

      iex> update_short_url(short_url, %{field: new_value})
      {:ok, %ShortUrl{}}

      iex> update_short_url(short_url, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_short_url(%Scope{} = scope, %ShortUrl{} = short_url, attrs) do
    true = short_url.user_id == scope.user.id

    with {:ok, %ShortUrl{} = short_url} <-
           short_url
           |> ShortUrl.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, short_url})
      {:ok, short_url}
    end
  end

  @doc """
  Deletes a short_url.

  ## Examples

      iex> delete_short_url(short_url)
      {:ok, %ShortUrl{}}

      iex> delete_short_url(short_url)
      {:error, %Ecto.Changeset{}}

  """
  def delete_short_url(%Scope{} = scope, %ShortUrl{} = short_url) do
    true = short_url.user_id == scope.user.id

    with {:ok, %ShortUrl{} = short_url} <-
           Repo.delete(short_url) do
      broadcast(scope, {:deleted, short_url})
      {:ok, short_url}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking short_url changes.

  ## Examples

      iex> change_short_url(short_url)
      %Ecto.Changeset{data: %ShortUrl{}}

  """
  def change_short_url(%Scope{} = scope, %ShortUrl{} = short_url, attrs \\ %{}) do
    true = short_url.user_id == scope.user.id

    ShortUrl.changeset(short_url, attrs, scope)
  end

  @doc """
  Generate human-friendly short URL
  """
  def generate_short_url do
    "short-" <> (20 |> :crypto.strong_rand_bytes() |> Base.encode32())
  end
end
