defmodule LlevaTildeBot.AsyncStore do
  alias LlevaTildeBot.Model.AnalyzedWord
  alias LlevaTildeBot.Store

  require Logger

  def store_user(%{id: telegram_id} = user) do
    params = %{
      telegram_id: telegram_id,
      first_name: Map.get(user, :first_name),
      username: Map.get(user, :username)
    }

    run_async(:user, fn -> Store.insert_user(params) end)
  end

  def store_user(user) do
    Logger.warning("Could not extract user from: #{inspect(user)}")
    :error
  end

  def store_analyzed_word(%AnalyzedWord{} = analyzed_word) do
    params = AnalyzedWord.to_map(analyzed_word)
    run_async(:analyzed_word, fn -> Store.insert_analyzed_word(params) end)
  end

  defp run_async(type, operation) do
    result =
      Task.Supervisor.start_child(LlevaTildeBot.StoreTaskSupervisor, fn ->
        case operation.() do
          {:ok, _record} -> :ok
          {:error, reason} -> Logger.error("Could not store #{type}: #{inspect(reason)}")
        end
      end)

    case result do
      {:ok, _pid} -> :ok
      {:error, reason} -> Logger.error("Could not start #{type} storage task: #{inspect(reason)}")
    end
  end
end
