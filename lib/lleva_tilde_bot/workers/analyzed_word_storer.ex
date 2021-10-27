defmodule LlevaTildeBot.Worker.AnalyzedWordStorer do
  use Oban.Worker, queue: :default

  alias LlevaTildeBot.Store
  alias LlevaTildeBot.Model.AnalyzedWord

  def enqueue(%AnalyzedWord{} = analyzed_word) do
    analyzed_word |> AnalyzedWord.to_map() |> new() |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: word_params}) do
    word = word_params["word"]

    case Store.find_analyzed_words(word: word) do
      [%AnalyzedWord{}] -> {:discard, "Analysis for word #{inspect(word)} already saved"}
      _ -> Store.insert_analyzed_word(word_params)
    end
  end
end
