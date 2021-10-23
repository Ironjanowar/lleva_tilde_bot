defmodule LlevaTildeBot.Scraper.Client do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://llevatilde.es")

  def get_word(word) do
    word = URI.encode(word)

    case get("/palabra/#{word}") do
      {:ok, %{body: html}} -> {:ok, html}
      _ -> :error
    end
  end
end
