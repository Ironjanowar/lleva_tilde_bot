defmodule LlevaTildeBot.Scraper.Parser do
  def parse_word_result(word, html) do
    with {:ok, document} <- Floki.parse_document(html) do
      result = %{
        word: word,
        syllables: get_syllables(document),
        analysis: get_analysis(document),
        conclusion: get_conclusion(document),
        reason: get_reason(document),
        result: get_result(document),
        warning: get_warning(document),
        diacritic_examples: get_diacritic_examples(document)
      }

      {:ok, result}
    end
  end

  def get_syllables(document) do
    document
    |> section_elements("Separación silábica")
    |> Enum.find(&has_class?(&1, "text-3xl"))
    |> clean_string()
  end

  def get_analysis(document) do
    document
    |> section_elements("Análisis:", :starts_with)
    |> first_text("p.resulttext")
  end

  defp get_conclusion(document) do
    document
    |> section_elements("Conclusión")
    |> first_text("p")
  end

  defp get_reason(document) do
    nodes = section_elements(document, "Aplicación de reglas")

    case text_list(nodes, "li") do
      [] -> first_text(nodes, "p")
      rules -> Enum.join(rules, " ")
    end
  end

  defp get_result(document) do
    document
    |> Floki.find(".warning + div.showtext")
    |> List.first()
    |> clean_string()
    |> empty_to_nil()
  end

  defp get_warning(document) do
    document
    |> Floki.find(".warning .text_warning")
    |> List.first()
    |> clean_string()
    |> empty_to_nil()
  end

  defp get_diacritic_examples(document) do
    document
    |> Floki.find("article div.resulttext")
    |> Enum.find(&(Floki.find(&1, ".diacriticWord") != []))
    |> child_elements()
    |> Enum.reduce([], &collect_diacritic_field/2)
    |> Enum.reverse()
    |> Enum.filter(&complete_diacritic_example?/1)
  end

  defp collect_diacritic_field(node, examples) do
    cond do
      has_class?(node, "diacriticWord") ->
        [%{word: clean_string(node), type: nil, example: nil} | examples]

      has_class?(node, "hometext") ->
        update_current_example(examples, :type, clean_string(node))

      has_class?(node, "diacriticText") ->
        update_current_example(examples, :example, clean_string(node))

      true ->
        examples
    end
  end

  defp update_current_example([], _field, _value), do: []

  defp update_current_example([example | rest], field, value) do
    [Map.put(example, field, value) | rest]
  end

  defp complete_diacritic_example?(example) do
    Enum.all?([example.word, example.type, example.example], &is_binary/1)
  end

  defp section_elements(document, heading, match \\ :exact) do
    document
    |> all_elements()
    |> Enum.find_value([], fn container ->
      elements = child_elements(container)

      case Enum.split_while(elements, &(not heading?(&1, heading, match))) do
        {_before, []} ->
          false

        {_before, [_heading | after_heading]} ->
          Enum.take_while(after_heading, &(element_tag(&1) != "h2"))
      end
    end)
  end

  defp heading?(node, heading, :exact) do
    element_tag(node) == "h2" and clean_string(node) == heading
  end

  defp heading?(node, heading, :starts_with) do
    element_tag(node) == "h2" and String.starts_with?(clean_string(node), heading)
  end

  defp first_text(nodes, selector) do
    nodes
    |> Floki.find(selector)
    |> List.first()
    |> clean_string()
  end

  defp text_list(nodes, selector) do
    nodes
    |> Floki.find(selector)
    |> Enum.map(&clean_string/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp all_elements(nodes) when is_list(nodes) do
    Enum.flat_map(nodes, &all_elements/1)
  end

  defp all_elements({_tag, _attributes, children} = node) do
    [node | all_elements(children)]
  end

  defp all_elements(_node), do: []

  defp child_elements(nil), do: []

  defp child_elements({_tag, _attributes, children}) do
    Enum.filter(children, &match?({_, _, _}, &1))
  end

  defp element_tag({tag, _attributes, _children}), do: tag
  defp element_tag(_node), do: nil

  defp has_class?({_tag, attributes, _children}, class) do
    attributes
    |> List.keyfind("class", 0, {"class", ""})
    |> elem(1)
    |> String.split()
    |> Enum.member?(class)
  end

  defp has_class?(_node, _class), do: false

  defp clean_string(nil), do: ""

  defp clean_string(node) do
    node
    |> Floki.text()
    |> String.replace(~r/\s+/u, " ")
    |> String.trim()
  end

  defp empty_to_nil(""), do: nil
  defp empty_to_nil(value), do: value
end
