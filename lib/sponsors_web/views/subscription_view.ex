defmodule SponsorsWeb.SubscriptionView do
  use Phoenix.Controller  # ✅ Phoenix 1.7에서는 View 대신 Controller 사용

  def render("index.json", %{subscriptions: subscriptions}) do
    %{
      data: Enum.map(subscriptions, &render_subscription/1)
    }
    # render_many(subscriptions, __MODULE__, "subscription.json")
  end

  def render("show.json", %{subscription: subscription}) do
    %{
      data: render_subscription(subscription)
    }
    # render_one(subscription, __MODULE__, "subscription.json")
  end

  def render("subscription.json", %{subscription: subscription}) do
    %{
      canceled_at: to_timestamp(subscription.canceled_at),
      expires_at: to_timestamp(subscription.expires_at),
      id: subscription.id,
      inserted_at: to_timestamp(subscription.inserted_at),
      stripe_source_id: subscription.stripe_source_id,
      stripe_subscription_id: subscription.stripe_subscription_id
    }
  end

  # ✅ `render_subscription/1` 함수 추가 (각 Subscription을 JSON으로 변환)
  defp render_subscription(subscription) do
    %{
      canceled_at: to_timestamp(subscription.canceled_at),
      expires_at: to_timestamp(subscription.expires_at),
      id: subscription.id,
      inserted_at: to_timestamp(subscription.inserted_at),
      stripe_source_id: subscription.stripe_source_id,
      stripe_subscription_id: subscription.stripe_subscription_id
    }
  end

  defp to_timestamp(nil), do: nil
  defp to_timestamp(dt), do: DateTime.to_unix(dt)
end
