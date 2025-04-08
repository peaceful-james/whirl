defmodule Whirl.Repo.Migrations.CreateShortUrl do
  use Ecto.Migration

  def change do
    create table(:short_url, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :long_url, :string
      add :short_url, :string
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
