defmodule LlevaTildeBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    token = ExGram.Config.get(:ex_gram, :token)

    children = [
      LlevaTildeBot.Repo,
      {Oban, oban_config()},
      ExGram,
      {LlevaTildeBot.Bot, [method: :polling, token: token]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LlevaTildeBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp oban_config do
    Application.fetch_env!(:lleva_tilde_bot, Oban)
  end
end
