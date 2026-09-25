import Config

config :lleva_tilde_bot, LlevaTildeBot.Repo,
  database: "lleva_tilde_bot.db",
  pool_size: 1,
  busy_timeout: 5_000

config :lleva_tilde_bot,
  ecto_repos: [LlevaTildeBot.Repo]

config :ex_gram,
  token: {:system, "BOT_TOKEN"},
  adapter: ExGram.Adapter.Req

config :logger, level: :info

config :logger, :default_formatter, format: "$dateT$timeZ [$level] $message\n"
