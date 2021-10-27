defmodule LlevaTildeBot.Model.DiacriticExample do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:word, :string)
    field(:type, :string)
    field(:example, :string)
  end

  @fields [:word, :type, :example]
  def changeset(%__MODULE__{} = schema \\ %__MODULE__{}, attrs) do
    Ecto.Changeset.cast(schema, attrs, @fields)
  end
end
