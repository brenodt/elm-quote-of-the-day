defmodule QuoteApi.DirectoryTest do
  use QuoteApi.DataCase

  alias QuoteApi.Directory

  describe "quotes" do
    alias QuoteApi.Directory.Quote

    @valid_attrs %{author_name: "some author_name", quote: "some quote", tag: "some tag"}
    @update_attrs %{author_name: "some updated author_name", quote: "some updated quote", tag: "some updated tag"}
    @invalid_attrs %{author_name: nil, quote: nil, tag: nil}

    def quote_fixture(attrs \\ %{}) do
      {:ok, quote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Directory.create_quote()

      quote
    end

    test "list_quotes/0 returns all quotes" do
      quote = quote_fixture()
      assert Directory.list_quotes() == [quote]
    end

    test "get_quote!/1 returns the quote with given id" do
      quote = quote_fixture()
      assert Directory.get_quote!(quote.id) == quote
    end

    test "create_quote/1 with valid data creates a quote" do
      assert {:ok, %Quote{} = quote} = Directory.create_quote(@valid_attrs)
      assert quote.author_name == "some author_name"
      assert quote.quote == "some quote"
      assert quote.tag == "some tag"
    end

    test "create_quote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Directory.create_quote(@invalid_attrs)
    end

    test "update_quote/2 with valid data updates the quote" do
      quote = quote_fixture()
      assert {:ok, %Quote{} = quote} = Directory.update_quote(quote, @update_attrs)
      assert quote.author_name == "some updated author_name"
      assert quote.quote == "some updated quote"
      assert quote.tag == "some updated tag"
    end

    test "update_quote/2 with invalid data returns error changeset" do
      quote = quote_fixture()
      assert {:error, %Ecto.Changeset{}} = Directory.update_quote(quote, @invalid_attrs)
      assert quote == Directory.get_quote!(quote.id)
    end

    test "delete_quote/1 deletes the quote" do
      quote = quote_fixture()
      assert {:ok, %Quote{}} = Directory.delete_quote(quote)
      assert_raise Ecto.NoResultsError, fn -> Directory.get_quote!(quote.id) end
    end

    test "change_quote/1 returns a quote changeset" do
      quote = quote_fixture()
      assert %Ecto.Changeset{} = Directory.change_quote(quote)
    end
  end
end
