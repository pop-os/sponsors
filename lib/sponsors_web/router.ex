defmodule SponsorsWeb.Router do
  use SponsorsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SponsorsWeb do
    pipe_through :api
  end
end
