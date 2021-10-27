defmodule LlevaTildeBot.MessageFormatter do
  alias LlevaTildeBot.Model.AnalyzedWord

  def help_command() do
    message = """
    Envía una palabra con una tilde donde dudes que debería ir.

    Por ejemplo:
      - _línea_
      - _esdrújula_
      - _monuménto_ (no lleva tilde)
      - _cása_ (no lleva tilde)
      - _cláramente_ (no lleva tilde)

    El bot contestará con un análisis de la palabra.
    """

    {message, [parse_mode: "Markdown"]}
  end

  def about_command() do
    message = """
    _Este bot lo ha hecho_ [@Ironjanowar](https://github.com/Ironjanowar) _con amor ❤_

    Si quieres dar un poco de apoyo deja una estrella ⭐ en el [repositorio](https://github.com/Ironjanowar/lleva_tilde_bot)

    También puedes usar la web https://llevatilde.es de la que se sacan los análisis. Este bot *no tiene relación con la web* solo extrae los análisis.
    """

    {message, [parse_mode: "Markdown"]}
  end

  def unknown_error() do
    message = "Ha ocurrido un error inesperado, lo siento :("
    {message, []}
  end

  def bad_input() do
    message = """
    Lo siento, solo puedo analizar palabras de una en una y con al menos una tilde donde creas que va la acentuación.

    Si necesitas ayuda manda el comando /help
    """

    {message, []}
  end

  def format_word_result(%AnalyzedWord{} = analyzed_word) do
    result = analyzed_word |> Map.from_struct() |> Enum.map(&format_result_field/1) |> Map.new()

    message =
      "📜 *#{result.word}* 📜\n"
      |> maybe_add(result.warning)
      |> maybe_add(result.syllables)
      |> maybe_add(result.analysis)
      |> maybe_add(result.conclusion)
      |> maybe_add(result.reason)
      |> maybe_add(result.result)
      |> maybe_add(result.diacritic_examples)

    {message, [parse_mode: "Markdown"]}
  end

  defp format_result_field({field, nil}), do: {field, nil}
  defp format_result_field({field, ""}), do: {field, nil}
  defp format_result_field({field, []}), do: {field, nil}
  defp format_result_field({:warning, warn}), do: {:warning, "⚠ #{warn}\n"}
  defp format_result_field({:syllables, syl}), do: {:syllables, "*Sílabas*\n  __#{syl}__\n"}
  defp format_result_field({:analysis, analysis}), do: {:analysis, "#{analysis}\n"}
  defp format_result_field({:reason, reason}), do: {:reason, "__Razón:__ #{reason}\n"}
  defp format_result_field({:result, result}), do: {:result, "#{result}"}
  defp format_result_field({:conclusion, con}), do: {:conclusion, "*Conclusión*\n#{con}\n"}

  defp format_result_field({:diacritic_examples, examples}),
    do: {:diacritic_examples, "*Se escribirá:*\n#{format_diacritic_examples(examples)}\n"}

  defp format_result_field(ignore), do: ignore

  defp maybe_add(text, []), do: text
  defp maybe_add(text, nil), do: text
  defp maybe_add(text, ""), do: text
  defp maybe_add(text, to_add), do: "#{text}\n#{to_add}"

  defp format_diacritic_examples(examples) do
    examples
    |> Enum.map(fn %{word: word, type: type, example: example} ->
      "\n  *#{word}* #{type}\n    _#{example}_"
    end)
    |> Enum.join("\n")
  end
end
