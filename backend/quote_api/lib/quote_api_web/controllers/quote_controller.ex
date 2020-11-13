defmodule QuoteApiWeb.QuoteController do
  use QuoteApiWeb, :controller

  alias QuoteApi.Directory
  alias QuoteApi.Directory.Quote

  action_fallback QuoteApiWeb.FallbackController

  def index(conn, _params) do
    quotes = Directory.list_quotes()
    render(conn, "index.json", quotes: quotes)
  end

  def create(conn, %{"quote" => quote_params}) do
    with {:ok, %Quote{} = quote} <- Directory.create_quote(quote_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.quote_path(conn, :show, quote))
      |> render("show.json", quote: quote)
    end
  end

  def show(conn, %{"id" => id}) do
    quote = Directory.get_quote!(id)
    render(conn, "show.json", quote: quote)
  end

  def update(conn, %{"id" => id, "quote" => quote_params}) do
    quote = Directory.get_quote!(id)

    with {:ok, %Quote{} = quote} <- Directory.update_quote(quote, quote_params) do
      render(conn, "show.json", quote: quote)
    end
  end

  def delete(conn, %{"id" => id}) do
    quote = Directory.get_quote!(id)

    with {:ok, %Quote{}} <- Directory.delete_quote(quote) do
      send_resp(conn, :no_content, "")
    end
  end
end
