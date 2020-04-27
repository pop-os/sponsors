ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Sponsors.Repo, :manual)
Application.ensure_all_started(:bypass)
Application.ensure_all_started(:ex_machina)

Mox.defmock(Sponsors.StripeMock, for: Sponsors.Stripe)
Mox.defmock(Sponsors.SubscriptionsMock, for: Sponsors.Subscriptions)

defmodule SponsorsWeb.AuthHelpers do
  @moduledoc """
  A few functions that make working with authentication during tests easier
  """

  @doc """
  Create an authenticated connection with the `customer_id` as the `sub`.

  We use `Guardian.Token.Jwt.create_token/2` directly rather than `encode_and_sign/2`
  since we don't implement, nor want to implement soley for testing, the Guardian callbacks
  used to encode resource's struct and load the subject from storage. 

  Neither functions are performed by this service.
  """
  def login(conn, customer_id, claim_overrides \\ %{}) do
    claims = Map.merge(%{"iss" => "system76", "sub" => customer_id, "typ" => "access"}, claim_overrides)

    {:ok, token} = Guardian.Token.Jwt.create_token(Sponsors.Guardian, claims)

    Plug.Conn.put_req_header(conn, "authorization", "Bearer " <> token)
  end
end
