defmodule SponsorsWeb.ErrorView do
  use Phoenix.Controller  # ✅ Phoenix 1.7에서는 View 대신 Controller 사용

  def render("400.json", _assigns) do
    %{errors: %{detail: "Bad Request"}}
  end

  def render("401.json", _assigns) do
    %{errors: %{detail: "Unauthorized"}}
  end

  def render("402.json", _assigns) do
    %{errors: %{detail: "Payment Required"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
