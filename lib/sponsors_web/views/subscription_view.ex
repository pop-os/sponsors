defmodule SponsorsWeb.SubscriptionView do
  use SponsorsWeb, :view

  def render("index.json", %{subscriptions: subscriptions}) do
    render_many(subscriptions, __MODULE__, "subscription.json")
  end

  def render("show.json", %{subscription: subscription}) do
    render_one(subscription, __MODULE__, "subscription.json")
  end

  def render("subscription.json", %{subscription: subscription}) do
    %{
      id: subscription.id,
      canceled_at: to_timestamp(subscription.canceled_at),
      expires_at: to_timestamp(subscription.canceled_at),
      inserted_at: to_timestamp(subscription.canceled_at)
    }

    Map.take(subscription, [:id, :canceled_at, :expires_at, :inserted_at])
  end

  defp to_timestamp(nil), do: nil
  defp to_timestamp(dt), do: DateTime.to_unix(dt)
end
