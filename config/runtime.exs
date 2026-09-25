import Config

if config_env() == :prod do
  database_path = System.fetch_env!("DATABASE_PATH")

  config :lleva_tilde_bot, LlevaTildeBot.Repo,
    database: database_path,
    pool_size: 1,
    busy_timeout: 5_000

  config :logger, level: :info
end
