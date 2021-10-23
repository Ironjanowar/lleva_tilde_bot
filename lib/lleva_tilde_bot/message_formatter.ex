defmodule LlevaTildeBot.MessageFormatter do
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

  def unknown_error() do
    message = "Ha ocurrido un error inesperado, lo siento :("
    {message, []}
  end

  def bad_input() do
    message =
      "Lo siento, solo puedo analizar una palabra a la vez. Si necesitas ayuda manda el comand /help"

    {message, []}
  end

  def format_word_result(word, result) do
    result = result |> Enum.map(&format_result_field/1) |> Map.new()

    message =
      "📜 *#{word}* 📜\n"
      |> maybe_add(result[:warning])
      |> maybe_add(result[:syllables])
      |> maybe_add(result[:analysis])
      |> maybe_add(result[:conclusion])
      |> maybe_add(result[:reason])
      |> maybe_add(result[:result])

    {message, [parse_mode: "Markdown"]}
  end

  defp format_result_field({field, nil}), do: {field, nil}
  defp format_result_field({field, ""}), do: {field, nil}
  defp format_result_field({:warning, warn}), do: {:warning, "⚠ #{warn}\n"}
  defp format_result_field({:syllables, syl}), do: {:syllables, "*Sílabas*\n  __#{syl}__\n"}
  defp format_result_field({:analysis, analysis}), do: {:analysis, "#{analysis}\n"}
  defp format_result_field({:reason, reason}), do: {:reason, "__Razón:__ #{reason}\n"}
  defp format_result_field({:result, result}), do: {:result, "#{result}"}
  defp format_result_field({:conclusion, con}), do: {:conclusion, "*Conclusión*\n#{con}\n"}
  defp format_result_field(ignore), do: ignore

  defp maybe_add(text, nil), do: text
  defp maybe_add(text, to_add), do: "#{text}\n#{to_add}"
end
