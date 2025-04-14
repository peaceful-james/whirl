defmodule Whirl.Repo.Migrations.CreateAxes do
  use Ecto.Migration

  def change do
    create table(:axes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :cardinality, :integer
      add :options, {:array, :string}
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
