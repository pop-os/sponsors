defmodule Sponsors.SubscriptionsTest do
  use Sponsors.DataCase

  import Mox

  alias Sponsors.Subscriptions

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
end
