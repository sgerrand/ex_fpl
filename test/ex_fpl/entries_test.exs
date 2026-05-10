defmodule ExFPL.EntriesTest do
  use ExUnit.Case, async: true

  import ExFPL.TestFixtures
  alias ExFPL.{Entries, Session}

  describe "get/2" do
    test "returns an Entry struct" do
      stub_json(entry())
      assert {:ok, %ExFPL.Entry{id: 12345, name: "My Team"}} = Entries.get(12345)
    end

    test "raw: true returns the original map" do
      stub_json(entry())
      assert {:ok, %{"id" => 12345}} = Entries.get(12345, raw: true)
    end

    test "surfaces HTTP errors" do
      Req.Test.stub(ExFPL.HTTPStub, fn conn -> Plug.Conn.send_resp(conn, 404, "") end)
      assert {:error, {:http_error, 404, _}} = Entries.get(12345, retry: false)
    end
  end

  describe "history/2" do
    test "returns an EntryHistory struct" do
      stub_json(entry_history())
      assert {:ok, %ExFPL.EntryHistory{current: [_]}} = Entries.history(12345)
    end

    test "raw: true returns the original map" do
      stub_json(entry_history())
      assert {:ok, %{"current" => _}} = Entries.history(12345, raw: true)
    end
  end

  describe "picks/3" do
    test "returns a Picks struct" do
      Req.Test.stub(ExFPL.HTTPStub, fn conn ->
        assert conn.request_path == "/api/entry/12345/event/3/picks/"
        Req.Test.json(conn, picks())
      end)

      assert {:ok, %ExFPL.Picks{picks: [%ExFPL.Pick{}]}} = Entries.picks(12345, 3)
    end

    test "raw: true returns the original map" do
      stub_json(picks())
      assert {:ok, %{"picks" => _}} = Entries.picks(12345, 3, raw: true)
    end
  end

  describe "me/1" do
    test "returns Me struct when given a session" do
      Req.Test.stub(ExFPL.HTTPStub, fn conn ->
        assert ["pl_profile=secret"] = Plug.Conn.get_req_header(conn, "cookie")
        Req.Test.json(conn, me())
      end)

      assert {:ok, %ExFPL.Me{watched: [1, 2, 3]}} =
               Entries.me(session: Session.new(cookie: "pl_profile=secret"))
    end

    test "raw: true returns the original map" do
      stub_json(me())

      assert {:ok, %{"player" => _}} =
               Entries.me(session: Session.new(cookie: "x"), raw: true)
    end

    test "raises without a session" do
      assert_raise ArgumentError, ~r/requires a session/, fn -> Entries.me([]) end
    end

    test "raises when session is not a struct" do
      assert_raise ArgumentError, fn -> Entries.me(session: "raw-cookie-string") end
    end
  end

  describe "my_team/2" do
    test "returns MyTeam struct when given a session" do
      stub_json(my_team())
      session = Session.new(cookie: "pl_profile=x")
      assert {:ok, %ExFPL.MyTeam{picks: [_]}} = Entries.my_team(12345, session: session)
    end

    test "raw: true returns the original map" do
      stub_json(my_team())
      session = Session.new(cookie: "pl_profile=x")
      assert {:ok, %{"picks" => _}} = Entries.my_team(12345, session: session, raw: true)
    end

    test "raises without a session" do
      assert_raise ArgumentError, fn -> Entries.my_team(12345, []) end
    end
  end
end
