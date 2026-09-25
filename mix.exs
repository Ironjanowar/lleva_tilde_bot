defmodule LlevaTildeBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :lleva_tilde_bot,
      version: "0.1.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {LlevaTildeBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram, "~> 0.70"},
      {:req, "~> 0.7.4"},
      {:jason, "~> 1.4"},
      {:logger_file_backend, "~> 0.1.1"},
      {:floki, "~> 0.38.4"},
      {:ecto_sql, "~> 3.14"},
      {:postgrex, "~> 0.22.4"},
      {:oban, "~> 2.24"}
    ]
  end
end
