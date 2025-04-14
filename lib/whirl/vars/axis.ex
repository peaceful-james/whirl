defmodule Whirl.Vars.Axis do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "axes" do
    field :name, :string
    field :cardinality, :integer
    field :options, {:array, :string}
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(axis, attrs, user_scope) do
    axis
    |> cast(attrs, [:name, :cardinality, :options])
    |> validate_required([:name, :cardinality, :options])
    |> put_change(:user_id, user_scope.user.id)
  end
end
