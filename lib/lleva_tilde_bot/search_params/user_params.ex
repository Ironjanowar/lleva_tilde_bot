defmodule LlevaTildeBot.SearchParams.UserParams do
  import Ecto.Query

  alias LlevaTildeBot.Model.User

  def search_params(params), do: from(User) |> search_params(params)
  def search_params(query, []), do: query

  def search_params(query, [{:id, id} | params]) when is_list(params) do
    query |> where([user], user.id == ^id) |> search_params(params)
  end

  def search_params(query, [{:telegram_id, telegram_id} | params]) when is_list(params) do
    query |> where([user], user.telegram_id == ^telegram_id) |> search_params(params)
  end

  def search_params(query, [{:limit, limit} | params]) when is_list(params) do
    query |> limit(^limit) |> search_params(params)
  end

  def search_params(query, [_ | params]) when is_list(params) do
    search_params(query, params)
  end
end
