ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Sponsors.Repo, :manual)
Application.ensure_all_started(:bypass)
Application.ensure_all_started(:ex_machina)

Mox.defmock(Sponsors.StripeMock, for: Sponsors.Stripe)
