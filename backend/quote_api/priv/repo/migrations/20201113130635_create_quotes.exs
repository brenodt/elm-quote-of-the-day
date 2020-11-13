defmodule QuoteApi.Repo.Migrations.CreateQuotes do
  use Ecto.Migration

  def change do
    create table(:quotes) do
      add :quote, :text
      add :author_name, :string
      add :tag, :string

      timestamps()
    end

  end
end
