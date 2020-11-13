defmodule QuoteApiWeb.QuoteView do
  use QuoteApiWeb, :view
  alias QuoteApiWeb.QuoteView

  def render("index.json", %{quotes: quotes}) do
    %{data: render_many(quotes, QuoteView, "quote.json")}
  end

  def render("show.json", %{quote: quote}) do
    %{data: render_one(quote, QuoteView, "quote.json")}
  end

  def render("quote.json", %{quote: quote}) do
    %{id: quote.id,
      quote: quote.quote,
      author_name: quote.author_name,
      tag: quote.tag}
  end
end
