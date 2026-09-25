defmodule LlevaTildeBot do
  alias LlevaTildeBot.{AsyncStore, MessageFormatter, Scraper, Store}
  alias LlevaTildeBot.Model.AnalyzedWord

  require Logger

  def get_word(text, from) do
    AsyncStore.store_user(from)

    with {:ok, word} <- parse_input(text),
         :ok <- check_acute_accent(word),
         {:ok, result} <- get_or_scrape_word(word) do
      AsyncStore.store_analyzed_word(result)
      MessageFormatter.format_word_result(result)
    else
      {:error, :bad_input} ->
        MessageFormatter.bad_input()

      error ->
        error |> inspect |> Logger.error()
        MessageFormatter.unknown_error()
    end
  end

  defp get_or_scrape_word(word) do
    case Store.find_analyzed_words(word: word) do
      [word] -> {:ok, word}
      _ -> scrape_word(word)
    end
  end

  defp scrape_word(word) do
    case Scraper.get_word(word) do
      {:ok, result} -> AnalyzedWord.build(result)
      _ -> {:error, "Could not scrape the word: #{inspect(word)}"}
    end
  end

  defp parse_input(text) when is_binary(text) do
    text
    |> String.trim()
    |> String.split(" ")
    |> case do
      [word] -> {:ok, String.downcase(word)}
      _ -> {:error, :bad_input}
    end
  end

  defp parse_input(_), do: {:error, :bad_input}

  @acute_accents ["á", "é", "í", "ó", "ú"]
  defp check_acute_accent(word) do
    if Enum.any?(@acute_accents, &String.contains?(word, &1)) do
      :ok
    else
      {:error, :bad_input}
    end
  end
end
