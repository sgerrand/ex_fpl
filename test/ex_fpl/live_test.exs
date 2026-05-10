defmodule ExFPL.LiveTest do
  use ExUnit.Case, async: true

  import ExFPL.TestFixtures
  alias ExFPL.Live

  test "fetch/2 returns a LiveSnapshot struct" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      assert conn.request_path == "/api/event/3/live/"
      Req.Test.json(conn, live())
    end)

    assert {:ok, %ExFPL.LiveSnapshot{elements: [%{"id" => 1}]}} = Live.fetch(3)
  end

  test "fetch/2 with raw: true returns the original map" do
    stub_json(live())
    assert {:ok, %{"elements" => _}} = Live.fetch(3, raw: true)
  end

  test "fetch/2 surfaces errors" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn -> Plug.Conn.send_resp(conn, 502, "") end)
    assert {:error, {:http_error, 502, _}} = Live.fetch(3, retry: false)
  end
end
