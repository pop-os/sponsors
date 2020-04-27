defmodule Sponsors.SubscriptionsTest do
  use Sponsors.DataCase

  import Mox
  import Sponsors.Factory

  alias Sponsors.{Repo, Subscriptions}
  alias Sponsors.Schemas.Subscription

  setup :verify_on_exit!

  describe "create/2" do
    test "returns a new subscription" do
      expected_subscription_id = "sub_ABCDExpected"

      expect(Sponsors.StripeMock, :subscribe, fn _stripe_customer ->
        {:ok, expected_subscription_id}
      end)

      assert {:ok, %{stripe_subscription_id: ^expected_subscription_id}} =
               Subscriptions.create("afakestripecustomer", "acustomerid")
    end
  end

  describe "cancel/1" do
    test "returns :ok upon successful cancelation" do
      %{id: id, stripe_subscription_id: stripe_subscription_id} = insert(:subscription)

      expect(Sponsors.StripeMock, :cancel, fn ^stripe_subscription_id ->
        {:ok, :ignored}
      end)

      assert :ok = Subscriptions.cancel(id)
      assert %{canceled: true, stripe_subscription_id: ^stripe_subscription_id} = Repo.get(Subscription, id)
    end
  end
end
