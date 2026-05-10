defmodule ExFPL.Leagues.ClassicTest do
  use ExUnit.Case, async: true

  import ExFPL.TestFixtures
  alias ExFPL.Leagues.Classic

  test "standings/2 returns a ClassicStandings struct" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      assert conn.query_string =~ "page_standings=1"
      Req.Test.json(conn, classic_standings())
    end)

    assert {:ok, %ExFPL.ClassicStandings{standings: [%ExFPL.ClassicStandings.Standing{rank: 1}]}} =
             Classic.standings(314)
  end

  test "standings/2 sends the requested page" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      assert conn.query_string =~ "page_standings=4"
      Req.Test.json(conn, classic_standings())
    end)

    assert {:ok, _} = Classic.standings(314, page: 4)
  end

  test "standings/2 with raw: true returns the original map" do
    stub_json(classic_standings())
    assert {:ok, %{"league" => _}} = Classic.standings(314, raw: true)
  end

  test "standings/2 surfaces errors" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn -> Plug.Conn.send_resp(conn, 500, "") end)
    assert {:error, {:http_error, 500, _}} = Classic.standings(314, retry: false)
  end
end
