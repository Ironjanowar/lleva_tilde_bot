import Config

if config_env() == :prod do
  database_url = System.fetch_env!("DATABASE_URL")

  config :lleva_tilde_bot, LlevaTildeBot.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE", "5"))

  config :logger,
    level: :info,
    backends: [:console]
end
