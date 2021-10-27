defmodule LlevaTildeBot.Repo.Migrations.CreateAnalizedWords do
  use Ecto.Migration

  def change do
    create table(:analyzed_words) do
      add(:word, :text)
      add(:warning, :text)
      add(:syllables, :text)
      add(:analysis, :text)
      add(:conclusion, :text)
      add(:reason, :text)
      add(:result, :text)
      add(:diacritic_examples, {:array, :jsonb})

      timestamps()
    end
  end
end
