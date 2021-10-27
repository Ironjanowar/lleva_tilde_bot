defmodule LlevaTildeBot.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:telegram_id, :integer)
      add(:first_name, :text)
      add(:username, :text)
      add(:uses, :integer)

      timestamps()
    end
  end
end
