defmodule SponsorsWeb.FallbackController do
  @moduledoc """
  Our Phoenix fallback controller for handling errors returned, not rendered, from controller
  functions.
  """
  use SponsorsWeb, :controller

  alias SponsorsWeb.ErrorView

  @doc """
  Handle Guardian pipeline errors. Regardless of reason we want to return the same
  message to everyone.
  """
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(401)
    |> put_view(ErrorView)
    |> render("401.json")
  end

  def call(conn, {:error, :missing_required_fields}) do
    conn
    |> put_status(400)
    |> put_view(ErrorView)
    |> render("400.json")
  end

  def call(conn, {:error, :stripe_payment_failed}) do
    conn
    |> put_status(402)
    |> put_view(ErrorView)
    |> render("402.json")
  end

  def call(conn, {:error, :subscription_not_found}) do
    conn
    |> put_status(404)
    |> put_view(ErrorView)
    |> render("404.json")
  end

  def call(conn, _error) do
    conn
    |> put_status(500)
    |> put_view(ErrorView)
    |> render("500.json")
  end
end
