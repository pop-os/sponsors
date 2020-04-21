defmodule Sponsors.Schemas.InvoiceTest do
  use Sponsors.DataCase

  import Sponsors.Factory

  alias Sponsors.Schemas.Invoice

  describe "changeset/2" do
    test "returns a valid changeset" do
      subscription = insert(:subscription)
      params = params_for(:invoice, subscription: subscription)

      assert %{valid?: true} = Invoice.changeset(%Invoice{}, params)
    end

    test "returns an invalid changeset when missing required fields" do
      without_subscription = params_for(:invoice, subscription: nil)
      assert %{valid?: false} = Invoice.changeset(%Invoice{}, without_subscription)

      without_invoice_id = params_for(:invoice, stripe_invoice_id: nil)
      assert %{valid?: false} = Invoice.changeset(%Invoice{}, without_invoice_id)
    end
  end
end
