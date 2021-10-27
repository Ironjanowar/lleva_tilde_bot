defmodule LlevaTildeBot.Repo do
  use Ecto.Repo,
    otp_app: :lleva_tilde_bot,
    adapter: Ecto.Adapters.Postgres
end
