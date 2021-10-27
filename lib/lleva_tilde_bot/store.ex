defmodule LlevaTildeBot.Store do
  alias LlevaTildeBot.Repo
  alias LlevaTildeBot.Model.{AnalyzedWord, User}
  alias LlevaTildeBot.SearchParams.{AnalyzedWordParams, UserParams}

  def insert_user(params) do
    params
    |> User.changeset()
    |> Repo.insert()
  end

  def find_users(params \\ []) do
    params
    |> UserParams.search_params()
    |> Repo.all()
  end

  def update_user_uses(%User{} = user) do
    user
    |> User.update_uses_changeset()
    |> Repo.update()
  end

  def insert_analyzed_word(params) do
    params
    |> AnalyzedWord.changeset()
    |> Repo.insert()
  end

  def find_analyzed_words(params \\ []) do
    params
    |> AnalyzedWordParams.search_params()
    |> Repo.all()
  end
end
