defmodule ExFPL.FixturesTest do
  use ExUnit.Case, async: true

  import ExFPL.TestFixtures
  alias ExFPL.Fixtures

  test "list/1 returns Fixture structs" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      assert conn.query_string == ""
      Req.Test.json(conn, [fixture()])
    end)

    assert {:ok, [%ExFPL.Fixture{id: 1}]} = Fixtures.list()
  end

  test "list/1 with event: gw forwards as a query param" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      assert conn.query_string =~ "event=5"
      Req.Test.json(conn, [])
    end)

    assert {:ok, []} = Fixtures.list(event: 5)
  end

  test "list/1 with raw: true returns plain maps" do
    stub_json([fixture()])
    assert {:ok, [%{"id" => 1}]} = Fixtures.list(raw: true)
  end

  test "list/1 surfaces errors" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      Plug.Conn.send_resp(conn, 500, "")
    end)

    assert {:error, {:http_error, 500, _}} = Fixtures.list(retry: false)
  end
end
