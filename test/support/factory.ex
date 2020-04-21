defmodule Sponsors.Factory do
  use ExMachina.Ecto, repo: Sponsors.Repo

  alias Sponsors.Schemas.{Invoice, Subscription}

  def invoice_factory do
    %Invoice{
      paid: false,
      stripe_invoice_id: sequence(:invoice_id, &"in_1GaOY2ALgoDNBXZTJGI2sn#{&1}"),
      subscription: build(:subscription)
    }
  end

  def subscription_factory do
    %Subscription{
      canceled: false,
      customer_id: sequence(:customer_id, &"1234#{&1}"),
      stripe_subscription_id: sequence(:subscription_id, &"sub_H8gD56NJYhAf#{&1}")
    }
  end
end
