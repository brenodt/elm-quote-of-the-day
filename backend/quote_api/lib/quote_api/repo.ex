defmodule QuoteApi.Repo do
  use Ecto.Repo,
    otp_app: :quote_api,
    adapter: Ecto.Adapters.Postgres
end
