defmodule QuoteApiWeb.Router do
  use QuoteApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", QuoteApiWeb do
    pipe_through :api
  end

  pipeline :browser do
    plug(:accepts, ["html"])
  end

  pipeline :auth do
    plug QuoteApiWeb.Auth.Pipeline
  end

  scope "/", QuoteApiWeb do
    pipe_through :browser
    get "/", DefaultController, :index
  end

  scope "/api", QuoteApiWeb do
    pipe_through :api
    post "/users/signup", UserController, :create
    post "/users/signin", UserController, :signin
  end

  scope "/api", QuoteApiWeb do
    pipe_through [:api, :auth]
    resources "/quotes", QuoteController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: QuoteApiWeb.Telemetry
    end
  end
end
