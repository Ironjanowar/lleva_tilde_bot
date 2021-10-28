defmodule LlevaTildeBot.Worker.UserStorer do
  use Oban.Worker, queue: :default

  alias LlevaTildeBot.Store
  alias LlevaTildeBot.Model.User

  require Logger

  def enqueue(%{id: telegram_id} = user) do
    %{telegram_id: telegram_id, first_name: user[:first_name], username: user[:username]}
    |> new()
    |> Oban.insert()
  end

  def enqueue(from) do
    Logger.error("Could not extract user from: #{inspect(from)}")
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: user_params}) do
    telegram_id = user_params["telegram_id"]

    case Store.find_users(telegram_id: telegram_id) do
      [%User{} = user] -> Store.update_user_uses(user)
      _ -> Store.insert_user(user_params)
    end
  end
end
