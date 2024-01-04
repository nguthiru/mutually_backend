defmodule Mutually.Repo do
  use Ecto.Repo,
    otp_app: :mutually,
    adapter: Ecto.Adapters.Postgres
end
