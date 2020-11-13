defmodule QuoteApi.Directory.Quote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "quotes" do
    field :author_name, :string
    field :quote, :string
    field :tag, :string

    timestamps()
  end

  @doc false
  def changeset(quote, attrs) do
    quote
    |> cast(attrs, [:quote, :author_name, :tag])
    |> validate_required([:quote, :author_name, :tag])
  end
end
