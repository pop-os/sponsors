defmodule SponsorsWeb.SubscriptionControllerTest do
  use SponsorsWeb.ConnCase

  import Mox
  import Sponsors.Factory

  alias SponsorsWeb.AuthHelpers

  setup :verify_on_exit!

  describe "index/2" do
    test "returns the logged in user's subscriptions", %{conn: conn} do
      %{customer_id: internal_customer_id, id: subscription_id} = subscription = insert(:subscription)

      expect(Sponsors.SubscriptionsMock, :all, fn ^internal_customer_id ->
        [subscription]
      end)

      assert [%{"id" => ^subscription_id}] =
               conn
               |> AuthHelpers.login(internal_customer_id)
               |> put_req_header("content-type", "application/json")
               |> get("/subscriptions")
               |> json_response(200)
    end
  end

  describe "create/2" do
    test "returns a 201 and our subscription resource", %{conn: conn} do
      internal_customer_id = "acustomer"
      expected_source = "card_expectedsource"

      expect(Sponsors.SubscriptionsMock, :create, fn _stripe_customer, internal_customer_id, ^expected_source ->
        {:ok, insert(:subscription, customer_id: internal_customer_id, stripe_source_id: expected_source)}
      end)

      body = %{
        stripe_customer_id: "astripecustomer",
        stripe_source_id: expected_source
      }

      assert %{"stripe_source_id" => ^expected_source} =
               conn
               |> AuthHelpers.login(internal_customer_id)
               |> put_req_header("content-type", "application/json")
               |> post("/subscriptions", Jason.encode!(body))
               |> json_response(201)
    end

    test "returns a 400 Bad Request when missing required fields", %{conn: conn} do
      conn
      |> AuthHelpers.login("acustomer")
      |> put_req_header("content-type", "application/json")
      |> post("/subscriptions", Jason.encode!(%{}))
      |> json_response(400)
    end

    test "returns a 401 Unauthorized when requests are missing a token", %{conn: conn} do
      conn
      |> put_req_header("content-type", "application/json")
      |> post("/subscriptions", Jason.encode!(%{}))
      |> json_response(401)
    end

    test "returns a 401 Unauthorized if token verification fails", %{conn: conn} do
      conn
      |> AuthHelpers.login("somecustomerid", %{"iss" => "notsystem76"})
      |> put_req_header("content-type", "application/json")
      |> post("/subscriptions", Jason.encode!(%{}))
      |> json_response(401)
    end

    test "returns a 402 Payment Required when payment fails", %{conn: conn} do
      expect(Sponsors.SubscriptionsMock, :create, fn _stripe_customer, _internal_customer_id, _source ->
        {:error, :stripe_payment_failed}
      end)

      body = %{
        stripe_customer_id: "astripecustomerid"
      }

      conn
      |> AuthHelpers.login("acustomer")
      |> put_req_header("content-type", "application/json")
      |> post("/subscriptions", Jason.encode!(body))
      |> json_response(402)
    end
  end

  describe "delete/2" do
    test "returns 205 No Content upon successful cancelation of a subscription", %{conn: conn} do
      %{customer_id: customer_id, id: subscription_id} = insert(:subscription)
      str_subscription_id = to_string(subscription_id)

      expect(Sponsors.SubscriptionsMock, :cancel, fn ^str_subscription_id ->
        :ok
      end)

      conn
      |> AuthHelpers.login(customer_id)
      |> delete("/subscriptions/#{subscription_id}")
      |> response(204)
    end

    test "returns 404 Not Found when trying to cancel a subscription that does not exist", %{conn: conn} do
      expect(Sponsors.SubscriptionsMock, :cancel, fn _subscription_id ->
        {:error, :subscription_not_found}
      end)

      conn
      |> AuthHelpers.login("acustomer")
      |> delete("/subscriptions/1")
      |> response(404)
    end

    test "returns 500 Internal Server Error when unable to cancel a subscription", %{conn: conn} do
      expect(Sponsors.SubscriptionsMock, :cancel, fn _subscription_id ->
        {:error, :subscription_cancelation_failed}
      end)

      conn
      |> AuthHelpers.login("acustomer")
      |> delete("/subscriptions/1")
      |> response(500)
    end
  end
end
