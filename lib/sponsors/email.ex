defmodule Sponsors.Email do
  import Bamboo.Email

  alias Bamboo.MailgunHelper

  def thank_you(email, first_name) do
    new_email()
    |> to(email)
    |> from("no-reply@system76.com")
    |> subject("Thank you for your supoprt!")
    |> MailgunHelper.template("thankyou")
    |> MailgunHelper.substitute_variables("name", first_name)
  end
end
