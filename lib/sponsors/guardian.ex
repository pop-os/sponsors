defmodule Sponsors.Guardian do
  use Guardian, otp_app: :sponsors

  def resource_from_claims(_claims), do: :not_implemented
  def subject_for_token(_resource, _claims), do: :not_implemented
end
