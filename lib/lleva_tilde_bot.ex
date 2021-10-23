defmodule LlevaTildeBot do
  alias LlevaTildeBot.{MessageFormatter, Scraper}

  require Logger

  def get_word(text) do
    with {:ok, word} <- parse_input(text),
         {:ok, result} <- Scraper.get_word(word) do
      MessageFormatter.format_word_result(word, result)
    else
      {:error, :bad_input} ->
        MessageFormatter.bad_input()

      error ->
        error |> inspect |> Logger.error()
        MessageFormatter.unknown_error()
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
end
