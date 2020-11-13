defmodule QuoteApiWeb.DefaultController do
	use QuoteApiWeb, :controller

	def index(conn, _params) do
		text conn, "QuoteAPI!"
	end
end