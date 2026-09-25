import Config

config :lleva_tilde_bot, LlevaTildeBot.Repo,
  database: "lleva_tilde_bot_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :lleva_tilde_bot,
  ecto_repos: [LlevaTildeBot.Repo]

config :ex_gram,
  token: {:system, "BOT_TOKEN"},
  adapter: ExGram.Adapter.Req

config :logger,
  level: :debug,
  truncate: :infinity,
  backends: [{LoggerFileBackend, :debug}, {LoggerFileBackend, :error}]

config :logger, :debug,
  path: "log/debug.log",
  level: :debug,
  format: "$dateT$timeZ [$level] $message\n"

config :logger, :error,
  path: "log/error.log",
  level: :error,
  format: "$dateT$timeZ [$level] $message\n"

config :lleva_tilde_bot, Oban,
  repo: LlevaTildeBot.Repo,
  pruner: Oban.Pruner,
  queues: [default: 10]
