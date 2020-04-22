# Sponsors

The API that powers the Pop!_OS donations.

## About

In order to support donations on the Pop!_OS website we need to interact with Stripe, this API encapsulates that interaction. For the initial release of donations we intend to support only a single annual subscription plan. As such the API has been designed with that in mind. In later iterations we may elect to support multiple subscription plans.

Creating user accounts, and stripe accounts, is handled by another service.

## Installation 

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.