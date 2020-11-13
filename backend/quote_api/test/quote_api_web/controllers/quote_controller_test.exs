defmodule QuoteApiWeb.QuoteControllerTest do
  use QuoteApiWeb.ConnCase

  alias QuoteApi.Directory
  alias QuoteApi.Directory.Quote

  @create_attrs %{
    author_name: "some author_name",
    quote: "some quote",
    tag: "some tag"
  }
  @update_attrs %{
    author_name: "some updated author_name",
    quote: "some updated quote",
    tag: "some updated tag"
  }
  @invalid_attrs %{author_name: nil, quote: nil, tag: nil}

  def fixture(:quote) do
    {:ok, quote} = Directory.create_quote(@create_attrs)
    quote
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all quotes", %{conn: conn} do
      conn = get(conn, Routes.quote_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create quote" do
    test "renders quote when data is valid", %{conn: conn} do
      conn = post(conn, Routes.quote_path(conn, :create), quote: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.quote_path(conn, :show, id))

      assert %{
               "id" => id,
               "author_name" => "some author_name",
               "quote" => "some quote",
               "tag" => "some tag"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.quote_path(conn, :create), quote: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update quote" do
    setup [:create_quote]

    test "renders quote when data is valid", %{conn: conn, quote: %Quote{id: id} = quote} do
      conn = put(conn, Routes.quote_path(conn, :update, quote), quote: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.quote_path(conn, :show, id))

      assert %{
               "id" => id,
               "author_name" => "some updated author_name",
               "quote" => "some updated quote",
               "tag" => "some updated tag"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, quote: quote} do
      conn = put(conn, Routes.quote_path(conn, :update, quote), quote: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete quote" do
    setup [:create_quote]

    test "deletes chosen quote", %{conn: conn, quote: quote} do
      conn = delete(conn, Routes.quote_path(conn, :delete, quote))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.quote_path(conn, :show, quote))
      end
    end
  end

  defp create_quote(_) do
    quote = fixture(:quote)
    %{quote: quote}
  end
end
