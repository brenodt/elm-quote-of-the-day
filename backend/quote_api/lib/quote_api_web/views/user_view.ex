defmodule QuoteApiWeb.UserView do
  use QuoteApiWeb, :view
  alias QuoteApiWeb.UserView

  def render("user.json", %{user: user, token: token}) do
    %{
      email: user.email,
      token: token
    }
  end
end
