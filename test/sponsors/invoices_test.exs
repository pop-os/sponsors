defmodule Sponsors.InvoicesTest do
  use Sponsors.DataCase
  use Bamboo.Test

  import Mox
  import Sponsors.Factory

  alias Sponsors.Schemas.Subscription
  alias Sponsors.{Email, Invoices, Repo}

  describe "create/5" do
    test "returns a new invoice after creating the record and emailing the customer" do
      stripe_customer_id = "cus_testcustomer"
      expected_email = Email.thank_you("user@example.com", "Test")

      %{id: subscription_id, stripe_subscription_id: stripe_subscription_id} = insert(:subscription)

      expect(Sponsors.StripeMock, :customer, fn ^stripe_customer_id ->
        {:ok, %{email: "user@example.com", name: "Test User"}}
      end)

      expected_expiration = ~U[2020-04-29 21:53:48Z]
      timestamp = DateTime.to_unix(expected_expiration)

      assert {:ok, _invoice} =
               Invoices.create("in_stripeinvoice", stripe_subscription_id, stripe_customer_id, timestamp, true)

      assert %{expires_at: ^expected_expiration} = Repo.get(Subscription, subscription_id)

      assert_delivered_email(expected_email)
    end
  end
end
