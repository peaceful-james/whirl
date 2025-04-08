defmodule Whirl.Urls.ShortUrl do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "short_url" do
    field :long_url, :string
    field :short_url, :string
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(short_url, attrs, user_scope) do
    short_url
    |> cast(attrs, [:long_url, :short_url])
    |> validate_required([:long_url, :short_url])
    |> put_change(:user_id, user_scope.user.id)
  end
end
