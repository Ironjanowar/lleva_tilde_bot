defmodule LlevaTildeBot.Scraper.Parser do
  def parse_word_result(html) do
    with {:ok, document} <- Floki.parse_document(html) do
      syllables = get_syllables(document)
      analysis = get_analysis(document)
      conclusion = get_conclusion(document)
      reason = get_reason(document)
      result = get_result(document)
      warning = get_warning(document)
      diacritic_examples = get_diacritic_examples(document)

      result =
        %{
          syllables: syllables,
          analysis: analysis,
          conclusion: conclusion,
          reason: reason,
          result: result,
          warning: warning,
          diacritic_examples: diacritic_examples
        }
        |> IO.inspect()

      {:ok, result}
    end
  end

  def get_syllables(document) do
    document
    |> Floki.find("article")
    |> Floki.find("div.word")
    |> Enum.at(0)
    |> clean_string()
  end

  def get_analysis(document) do
    document
    |> Floki.find("article")
    |> Floki.find("p.showtext")
    |> Enum.at(0)
    |> Floki.text()

    # |> Enum.map(&Floki.text/1)
    # |> Enum.find(&String.match?(&1, ~r/se analiza/i))
  end

  defp get_conclusion(document) do
    document
    |> Floki.find("article")
    |> Floki.find("p.resulttext")
    |> clean_string()
  end

  defp get_reason(document) do
    document
    |> Floki.find("article")
    |> Floki.find("p.showtext")
    |> Enum.at(1)
    |> clean_string
  end

  defp get_result(document) do
    result =
      document
      |> Floki.find("article")
      |> Floki.find("div.resulttext")
      |> Enum.at(1)
      |> clean_string()

    correct_word = get_correct_word(document)

    case {result, correct_word} do
      {"", _} -> nil
      {_, ""} -> nil
      {result, correct_word} -> "#{result} *#{correct_word}*"
    end
  end

  defp get_correct_word(document) do
    document
    |> Floki.find("article")
    |> Floki.find("div.word")
    |> Enum.at(1)
    |> clean_string()
  end

  defp get_warning(document) do
    document
    |> Floki.find("article")
    |> Floki.find("div.warning")
    |> Floki.find(".text_warning")
    |> clean_string()
  end

  defp get_diacritic_examples(document) do
    parent =
      document
      |> Floki.find("article")
      |> Floki.find("div.resulttext")

    diacritic_words =
      Floki.find(parent, "div.diacriticWord")
      |> Enum.map(&clean_string/1)

    diacritic_word_types =
      Floki.find(parent, "div.hometext")
      |> Enum.map(&clean_string/1)

    diacritic_examples =
      Floki.find(parent, "div.diacriticText")
      |> Enum.map(&clean_string/1)

    Enum.zip_with([diacritic_words, diacritic_word_types, diacritic_examples], &to_diacritic/1)
  end

  defp to_diacritic([word, type, example]), do: %{word: word, type: type, example: example}

  defp clean_string(string) do
    string
    |> Floki.text()
    |> String.replace("\n", "")
    |> String.trim()
  end
end
