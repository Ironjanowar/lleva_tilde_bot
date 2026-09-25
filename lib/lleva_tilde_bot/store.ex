defmodule LlevaTildeBot.Store do
  alias LlevaTildeBot.Repo
  alias LlevaTildeBot.Model.{AnalyzedWord, User}
  alias LlevaTildeBot.SearchParams.{AnalyzedWordParams, UserParams}

  def insert_user(params) do
    params
    |> User.changeset()
    |> Repo.insert(
      on_conflict: [inc: [uses: 1]],
      conflict_target: [:telegram_id]
    )
  end

  def find_users(params \\ []) do
    params
    |> UserParams.search_params()
    |> Repo.all()
  end

  def insert_analyzed_word(params) do
    params
    |> AnalyzedWord.changeset()
    |> Repo.insert(on_conflict: :nothing, conflict_target: [:word])
  end

  def find_analyzed_words(params \\ []) do
    params
    |> AnalyzedWordParams.search_params()
    |> Repo.all()
  end
end
