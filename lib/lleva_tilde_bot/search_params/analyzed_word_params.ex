defmodule LlevaTildeBot.SearchParams.AnalyzedWordParams do
  import Ecto.Query

  alias LlevaTildeBot.Model.AnalyzedWord

  def search_params(params), do: from(AnalyzedWord) |> search_params(params)
  def search_params(query, []), do: query

  def search_params(query, [{:id, id} | params]) when is_list(params) do
    query |> where([analyzed_word], analyzed_word.id == ^id) |> search_params(params)
  end

  def search_params(query, [{:word, word} | params]) when is_list(params) do
    query |> where([analyzed_word], analyzed_word.word == ^word) |> search_params(params)
  end

  def search_params(query, [{:limit, limit} | params]) when is_list(params) do
    query |> limit(^limit) |> search_params(params)
  end

  def search_params(query, [_ | params]) when is_list(params) do
    search_params(query, params)
  end
end
