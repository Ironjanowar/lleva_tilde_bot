defmodule LlevaTildeBot.Repo.Migrations.CreateSQLiteStore do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:telegram_id, :integer, null: false)
      add(:first_name, :text)
      add(:username, :text)
      add(:uses, :integer, null: false, default: 1)

      timestamps()
    end

    create(unique_index(:users, [:telegram_id]))

    create table(:analyzed_words) do
      add(:word, :text, null: false)
      add(:warning, :text)
      add(:syllables, :text)
      add(:analysis, :text)
      add(:conclusion, :text)
      add(:reason, :text)
      add(:result, :text)
      add(:diacritic_examples, {:array, :map}, null: false, default: [])

      timestamps()
    end

    create(unique_index(:analyzed_words, [:word]))
  end
end