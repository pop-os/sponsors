defmodule SponsorsWeb.ErrorViewTest do
  use ExUnit.Case, async: true

  test "renders 400.json" do
    assert SponsorsWeb.ErrorView.render("400.json", %{}) == %{errors: %{detail: "Bad Request"}}
  end

  test "renders 401.json" do
    assert SponsorsWeb.ErrorView.render("401.json", %{}) == %{errors: %{detail: "Unauthorized"}}
  end

  test "renders 402.json" do
    assert SponsorsWeb.ErrorView.render("402.json", %{}) == %{errors: %{detail: "Payment Required"}}
  end

  test "renders 500.json" do
    assert SponsorsWeb.ErrorView.render("500.json", %{}) == %{errors: %{detail: "Internal Server Error"}}
  end

  test "renders 404.json via template_not_found" do
    assert SponsorsWeb.ErrorView.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end
end
