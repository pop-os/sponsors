defmodule SponsorsWeb.HealthCheckControllerTest do
  use SponsorsWeb.ConnCase

  describe "health_check/2" do
    test "returns 200 with a message", %{conn: conn} do
      assert %{"msg" => "hi"} =
               conn
               |> get("health_check")
               |> json_response(200)
    end
  end
end
