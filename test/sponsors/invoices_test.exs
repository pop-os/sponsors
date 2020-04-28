defmodule Sponsors.InvoicesTest do
  use Sponsors.DataCase
  use Bamboo.Test

  import Mox
  import Sponsors.Factory

  alias Sponsors.Schemas.Invoice
  alias Sponsors.{Email, Invoices, Repo}

  describe "create/4" do
    test "returns a new invoice after creating the record and emailing the customer" do
      stripe_customer_id = "cus_testcustomer"
      expected_invoice_id = "in_testinvoice"
      expected_email = Email.thank_you("user@example.com", "Test")

      %{stripe_subscription_id: stripe_subscription_id} = insert(:subscription)

      expect(Sponsors.StripeMock, :customer, fn ^stripe_customer_id ->
        {:ok, %{email: "user@example.com", name: "Test User"}}
      end)

      assert :ok = Invoices.create(expected_invoice_id, stripe_subscription_id, stripe_customer_id, true)

      assert_delivered_email(expected_email)

      assert [%{stripe_invoice_id: ^expected_invoice_id, paid: true}] = Repo.all(Invoice)
    end
  end
end
