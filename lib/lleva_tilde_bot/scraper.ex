defmodule LlevaTildeBot.Scraper do
  alias LlevaTildeBot.Scraper.{Client, Parser}

  def get_word(word) do
    with {:ok, html} <- Client.get_word(word) do
      Parser.parse_word_result(html)
    end
  end
end
