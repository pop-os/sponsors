defmodule Sponsors.SubscriptionsTest do
  use Sponsors.DataCase

  import Mox
  import Sponsors.Factory

  alias Sponsors.{Repo, Subscriptions}
  alias Sponsors.Schemas.Subscription

  setup :verify_on_exit!

  describe "all/1" do
    test "returns a customer's subscriptions" do
      %{customer_id: customer_id, id: subscription_id} = insert(:subscription)

      assert [%{id: ^subscription_id}] = Subscriptions.all(customer_id)
    end
  end

  describe "create/2" do
    test "returns a new subscription" do
      expected_subscription_id = "sub_ABCDExpected"

      expect(Sponsors.StripeMock, :subscribe, fn _stripe_customer, _source ->
        timestamp = DateTime.to_unix(DateTime.utc_now())
        {:ok, %{current_period_end: timestamp, id: expected_subscription_id}}
      end)

      assert {:ok, %{stripe_subscription_id: ^expected_subscription_id}} =
               Subscriptions.create("afakestripecustomer", "acustomerid", "afakesource")
    end
  end

  describe "cancel/1" do
    test "returns :ok upon successful cancelation" do
      %{id: id, stripe_subscription_id: stripe_subscription_id} = insert(:subscription)

      expect(Sponsors.StripeMock, :cancel, fn ^stripe_subscription_id ->
        {:ok, :ignored}
      end)

      assert :ok = Subscriptions.cancel(id)
      assert %{canceled_at: canceled_at, stripe_subscription_id: ^stripe_subscription_id} = Repo.get(Subscription, id)
      refute is_nil(canceled_at)
    end
  end
end
