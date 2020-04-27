defmodule SponsorsWeb.SubscriptionView do
  use SponsorsWeb, :view

  def render("show.json", %{subscription: subscription}) do
    Map.take(subscription, [:customer_id, :id, :inserted_at])
  end
end
