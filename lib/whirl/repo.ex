defmodule Whirl.Repo do
  use Ecto.Repo,
    otp_app: :whirl,
    adapter: Ecto.Adapters.Postgres
end
