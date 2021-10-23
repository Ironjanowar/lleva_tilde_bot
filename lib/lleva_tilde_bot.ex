defmodule LlevaTildeBot do
  alias LlevaTildeBot.{MessageFormatter, Scraper}

  require Logger

  def get_word(text) do
    with {:ok, word} <- parse_input(text),
         :ok <- check_acute_accent(word),
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

  @acute_accents ["á", "é", "í", "ó", "ú"]
  defp check_acute_accent(word) do
    if Enum.any?(@acute_accents, &String.contains?(word, &1)) do
      :ok
    else
      {:error, :bad_input}
    end
  end
end
