defmodule LlevaTildeBot.Model.AnalyzedWord do
  use Ecto.Schema

  alias LlevaTildeBot.Model.DiacriticExample
  alias Ecto.Changeset

  schema "analyzed_words" do
    field(:word, :string)
    field(:warning, :string)
    field(:syllables, :string)
    field(:analysis, :string)
    field(:conclusion, :string)
    field(:reason, :string)
    field(:result, :string)

    embeds_many(:diacritic_examples, DiacriticExample)

    timestamps()
  end

  @fields [
    :word,
    :warning,
    :syllables,
    :analysis,
    :conclusion,
    :reason,
    :result
  ]
  def changeset(%__MODULE__{} = schema \\ %__MODULE__{}, attrs) do
    schema
    |> Changeset.cast(attrs, @fields)
    |> Changeset.cast_embed(:diacritic_examples)
  end

  def build(attrs) do
    attrs
    |> changeset()
    |> Changeset.apply_action(:insert)
  end

  def to_map(%__MODULE__{} = analyzed_word) do
    fields = @fields ++ [:diacritic_examples]
    diacritic_examples = Enum.map(analyzed_word.diacritic_examples, &DiacriticExample.to_map/1)

    analyzed_word
    |> Map.from_struct()
    |> Map.put(:diacritic_examples, diacritic_examples)
    |> Map.take(fields)
  end
end
