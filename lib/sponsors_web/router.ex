defmodule SponsorsWeb.Router do
  use SponsorsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug SponsorsWeb.AuthPipeline
  end

  scope "/webhooks", SponsorsWeb.Webhooks do
    pipe_through :api

    post "/stripe", StripeController, :create
  end

  scope "/", SponsorsWeb do
    pipe_through [:api, :auth]

    resources "/subscriptions", SubscriptionController, only: [:create, :delete, :index]
  end
end
