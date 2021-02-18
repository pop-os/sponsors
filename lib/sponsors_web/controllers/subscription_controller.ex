defmodule SponsorsWeb.SubscriptionController do
  @moduledoc """
  Provides the HTTP functionality around Subscriptions.
  """
  use SponsorsWeb, :controller

  action_fallback SponsorsWeb.FallbackController

  def index(conn, _params) do
    internal_customer_id = Guardian.Plug.current_resource(conn)
    subscriptions = subscriptions().all(internal_customer_id)
    render(conn, "index.json", subscriptions: subscriptions)
  end

  @doc """
  New subscriptions require a valid JWT from the authentication system and
  a JSON payload that includes our "stripe_customer_id".
  """
  def create(conn, %{"stripe_customer_id" => stripe_customer_id} = params) do
    with internal_customer_id when not is_nil(internal_customer_id) <- Guardian.Plug.current_resource(conn),
         alt_source = Map.get(params, "stripe_source_id"),
         {:ok, subscription} <- subscriptions().create(stripe_customer_id, internal_customer_id, alt_source) do
      conn
      |> put_status(201)
      |> render("show.json", subscription: subscription)
    end
  end

  def create(_conn, _params) do
    {:error, :missing_required_fields}
  end

  def delete(conn, %{"id" => subscription_id}) do
    with :ok <- subscriptions().cancel(subscription_id) do
      send_resp(conn, 204, "")
    end
  end

  defp subscriptions, do: Application.get_env(:sponsors, :subscription_module)
end
