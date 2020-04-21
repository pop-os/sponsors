defmodule Sponsors.StripeTest do
  use ExUnit.Case

  alias Sponsors.Stripe

  describe "subscribe/2" do
    setup do
      bypass = Bypass.open()
      Application.put_env(:stripity_stripe, :api_base_url, "http://localhost:#{bypass.port}/")

      {:ok, bypass: bypass}
    end

    test "returns an active subscription", %{bypass: bypass} do
      expected_subscription_id = "sub_ABCDExpected"

      Bypass.expect(bypass, fn conn ->
        resp =
          Jason.encode!(%{
            id: expected_subscription_id,
            object: "subscription",
            status: "active"
          })

        Plug.Conn.send_resp(conn, 200, resp)
      end)

      assert {:ok, ^expected_subscription_id} = Stripe.subscribe("afakestripecustomer")
    end

    test "returns an incomplete subscription on payment fail", %{bypass: bypass} do
      expected_subscription_id = "sub_ABCDExpected"

      Bypass.expect(bypass, fn conn ->
        resp =
          Jason.encode!(%{
            id: expected_subscription_id,
            object: "subscription",
            status: "incomplete"
          })

        Plug.Conn.send_resp(conn, 200, resp)
      end)

      assert {:error, :stripe_payment_failed} = Stripe.subscribe("afakestripecustomer")
    end

    test "returns an error tuple for unexpected Stripe errors", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.send_resp(conn, 500, "")
      end)

      assert {:error, _} = Stripe.subscribe("afakestripecustomer")
    end
  end
end
