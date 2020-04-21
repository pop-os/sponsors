defmodule SponsorsWeb.Router do
  use SponsorsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug SponsorsWeb.AuthPipeline
  end

  scope "/", SponsorsWeb do
    pipe_through :api

    get "/health_check", HealthCheckController, :health_check

    scope "/webhooks", Webhooks do
      post "/stripe", StripeController, :create
    end
  end

  scope "/", SponsorsWeb do
    pipe_through [:api, :auth]

    resources "/subscriptions", SubscriptionController, only: [:create, :delete]
  end
end
