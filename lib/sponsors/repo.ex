defmodule Sponsors.Repo do
  use Ecto.Repo,
    otp_app: :sponsors,
    adapter: Ecto.Adapters.Postgres
end
