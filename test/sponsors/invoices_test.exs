defmodule Sponsors.InvoicesTest do
  use Sponsors.DataCase

  import Sponsors.Factory

  alias Sponsors.{Invoices, Repo}
  alias Sponsors.Schemas.Subscription

  describe "create/4" do
    test "returns a new invoice and updates the subscription expiration" do
      %{id: subscription_id, stripe_subscription_id: stripe_subscription_id} = insert(:subscription)

      expected_expiration = ~U[2020-04-29 21:53:48Z]
      timestamp = DateTime.to_unix(expected_expiration)
      assert {:ok, _invoice} = Invoices.create("in_stripeinvoice", stripe_subscription_id, timestamp, true)

      assert %{expires_at: ^expected_expiration} = Repo.get(Subscription, subscription_id)
    end
  end
end
