defmodule LlevaTildeBot.Model.User do
  use Ecto.Schema

  alias Ecto.Changeset

  schema "users" do
    field(:telegram_id, :integer, null: false)
    field(:first_name, :string)
    field(:username, :string)
    field(:uses, :integer, default: 1)

    timestamps()
  end

  @fields [:telegram_id, :first_name, :username]
  @required [:telegram_id]
  def changeset(%__MODULE__{} = schema \\ %__MODULE__{}, attrs) do
    schema
    |> Changeset.cast(attrs, @fields)
    |> Changeset.validate_required(@required)
  end

  def update_uses_changeset(%__MODULE__{} = user) do
    Changeset.change(user, uses: user.uses + 1)
  end
end
