defmodule Whirl.Vars do
  @moduledoc """
  The Vars context.
  """

  import Ecto.Query, warn: false

  alias Whirl.Accounts.Scope
  alias Whirl.Repo
  alias Whirl.Vars.Axis

  @doc """
  Subscribes to scoped notifications about any axis changes.

  The broadcasted messages match the pattern:

    * {:created, %Axis{}}
    * {:updated, %Axis{}}
    * {:deleted, %Axis{}}

  """
  def subscribe_axes(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Whirl.PubSub, "user:#{key}:axes")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Whirl.PubSub, "user:#{key}:axes", message)
  end

  @doc """
  Returns the list of axes.

  ## Examples

      iex> list_axes(scope)
      [%Axis{}, ...]

  """
  def list_axes(%Scope{} = scope) do
    Repo.all(from axis in Axis, where: axis.user_id == ^scope.user.id)
  end

  @doc """
  Gets a single axis.

  Raises `Ecto.NoResultsError` if the Axis does not exist.

  ## Examples

      iex> get_axis!(123)
      %Axis{}

      iex> get_axis!(456)
      ** (Ecto.NoResultsError)

  """
  def get_axis!(%Scope{} = scope, id) do
    Repo.get_by!(Axis, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a axis.

  ## Examples

      iex> create_axis(%{field: value})
      {:ok, %Axis{}}

      iex> create_axis(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_axis(%Scope{} = scope, attrs \\ %{}) do
    with {:ok, %Axis{} = axis} <-
           %Axis{}
           |> Axis.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, axis})
      {:ok, axis}
    end
  end

  @doc """
  Updates a axis.

  ## Examples

      iex> update_axis(axis, %{field: new_value})
      {:ok, %Axis{}}

      iex> update_axis(axis, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_axis(%Scope{} = scope, %Axis{} = axis, attrs) do
    true = axis.user_id == scope.user.id

    with {:ok, %Axis{} = axis} <-
           axis
           |> Axis.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, axis})
      {:ok, axis}
    end
  end

  @doc """
  Deletes a axis.

  ## Examples

      iex> delete_axis(axis)
      {:ok, %Axis{}}

      iex> delete_axis(axis)
      {:error, %Ecto.Changeset{}}

  """
  def delete_axis(%Scope{} = scope, %Axis{} = axis) do
    true = axis.user_id == scope.user.id

    with {:ok, %Axis{} = axis} <-
           Repo.delete(axis) do
      broadcast(scope, {:deleted, axis})
      {:ok, axis}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking axis changes.

  ## Examples

      iex> change_axis(axis)
      %Ecto.Changeset{data: %Axis{}}

  """
  def change_axis(%Scope{} = scope, %Axis{} = axis, attrs \\ %{}) do
    true = axis.user_id == scope.user.id

    Axis.changeset(axis, attrs, scope)
  end
end
