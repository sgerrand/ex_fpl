defmodule ExFPL.Leagues.H2HTest do
  use ExUnit.Case, async: true

  import ExFPL.TestFixtures
  alias ExFPL.Leagues.H2H

  describe "standings/2" do
    test "returns an H2HStandings struct" do
      stub_json(h2h_standings())

      assert {:ok, %ExFPL.H2HStandings{standings: [%ExFPL.H2HStandings.Standing{}]}} =
               H2H.standings(999)
    end

    test "raw: true returns the original map" do
      stub_json(h2h_standings())
      assert {:ok, %{"league" => _}} = H2H.standings(999, raw: true)
    end

    test "surfaces errors" do
      Req.Test.stub(ExFPL.HTTPStub, fn conn -> Plug.Conn.send_resp(conn, 503, "") end)
      assert {:error, {:http_error, 503, _}} = H2H.standings(999, retry: false)
    end
  end

  describe "matches/2" do
    test "returns a list of H2HMatch structs" do
      Req.Test.stub(ExFPL.HTTPStub, fn conn ->
        assert conn.query_string =~ "page=1"
        refute conn.query_string =~ "event="
        Req.Test.json(conn, h2h_matches_response())
      end)

      assert {:ok, [%ExFPL.H2HMatch{event: 1}]} = H2H.matches(999)
    end

    test "with event sends event query param" do
      Req.Test.stub(ExFPL.HTTPStub, fn conn ->
        assert conn.query_string =~ "event=2"
        Req.Test.json(conn, h2h_matches_response())
      end)

      assert {:ok, _} = H2H.matches(999, event: 2)
    end

    test "raw: true returns the original map" do
      stub_json(h2h_matches_response())
      assert {:ok, %{"results" => _}} = H2H.matches(999, raw: true)
    end

    test "surfaces errors" do
      Req.Test.stub(ExFPL.HTTPStub, fn conn -> Plug.Conn.send_resp(conn, 500, "") end)
      assert {:error, {:http_error, 500, _}} = H2H.matches(999, retry: false)
    end
  end
end
