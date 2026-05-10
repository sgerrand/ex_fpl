defmodule ExFPL.PlayersTest do
  use ExUnit.Case, async: true

  import ExFPL.TestFixtures
  alias ExFPL.Players

  test "summary/2 returns a PlayerSummary struct" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      assert conn.request_path == "/api/element-summary/7/"
      Req.Test.json(conn, player_summary())
    end)

    assert {:ok, %ExFPL.PlayerSummary{fixtures: [_], history: [_]}} = Players.summary(7)
  end

  test "summary/2 with raw: true returns the original map" do
    stub_json(player_summary())
    assert {:ok, %{"history" => _}} = Players.summary(7, raw: true)
  end

  test "summary/2 surfaces errors" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn -> Plug.Conn.send_resp(conn, 404, "") end)
    assert {:error, {:http_error, 404, _}} = Players.summary(7, retry: false)
  end
end
