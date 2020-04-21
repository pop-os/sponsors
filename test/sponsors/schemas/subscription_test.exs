defmodule Sponsors.Schemas.SubscriptionTest do
  use Sponsors.DataCase

  import Sponsors.Factory

  alias Sponsors.Schemas.Subscription

  describe "changeset/2" do
    test "returns a valid changeset" do
      params = params_for(:subscription)
      assert %{valid?: true} = Subscription.changeset(%Subscription{}, params)
    end

    test "returns an invalid changeset when missing required fields" do
      without_customer = params_for(:subscription, customer_id: nil)
      assert %{valid?: false} = Subscription.changeset(%Subscription{}, without_customer)
    end
  end
end
