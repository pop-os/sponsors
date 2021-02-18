defmodule Sponsors.Guardian do
  use Guardian, otp_app: :sponsors

  def resource_from_claims(%{"sub" => "user:" <> user_id}) do
    {:ok, user_id}
  end

  def resource_from_claims(_claims), do: :not_implemented
  def subject_for_token(_resource, _claims), do: :not_implemented
end
