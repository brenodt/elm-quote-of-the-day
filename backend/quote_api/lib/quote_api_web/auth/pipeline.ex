defmodule QuoteApiWeb.Auth.Pipeline do
	use Guardian.Plug.Pipeline, otp_app: :quote_api,
		module: QuoteApiWeb.Auth.Guardian,
		error_handler: QuoteApiWeb.Auth.ErrorHandler

	plug Guardian.Plug.VerifyHeader
	plug Guardian.Plug.EnsureAuthenticated
	plug Guardian.Plug.LoadResource
end