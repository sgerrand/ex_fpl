defmodule ExFPL.BootstrapTest do
  use ExUnit.Case, async: false

  import ExFPL.TestFixtures
  alias ExFPL.{Bootstrap, Cache}

  setup do
    Cache.invalidate(:all)
    :ok
  end

  test "fetch/1 returns a Snapshot struct" do
    stub_json(bootstrap())

    assert {:ok, %ExFPL.Snapshot{teams: [%ExFPL.Team{}], players: [%ExFPL.Player{}]}} =
             Bootstrap.fetch()
  end

  test "fetch/1 caches the result by default" do
    {:ok, count} = Agent.start_link(fn -> 0 end)

    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      Agent.update(count, &(&1 + 1))
      Req.Test.json(conn, bootstrap())
    end)

    {:ok, _} = Bootstrap.fetch()
    {:ok, _} = Bootstrap.fetch()

    assert Agent.get(count, & &1) == 1
  end

  test "fetch/1 with cache: false bypasses the cache" do
    {:ok, count} = Agent.start_link(fn -> 0 end)

    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      Agent.update(count, &(&1 + 1))
      Req.Test.json(conn, bootstrap())
    end)

    {:ok, _} = Bootstrap.fetch(cache: false)
    {:ok, _} = Bootstrap.fetch(cache: false)

    assert Agent.get(count, & &1) == 2
  end

  test "fetch/1 with raw: true returns the original map" do
    stub_json(bootstrap())
    assert {:ok, %{"teams" => _, "elements" => _}} = Bootstrap.fetch(raw: true)
  end

  test "fetch/1 raw and decoded share separate cache buckets" do
    stub_json(bootstrap())
    {:ok, snap} = Bootstrap.fetch()
    {:ok, raw} = Bootstrap.fetch(raw: true)

    assert match?(%ExFPL.Snapshot{}, snap)
    assert match?(%{"teams" => _}, raw)
  end

  test "fetch/1 surfaces HTTP errors" do
    Req.Test.stub(ExFPL.HTTPStub, fn conn ->
      conn
      |> Plug.Conn.put_resp_content_type("application/json")
      |> Plug.Conn.send_resp(503, ~s({"error":"unavailable"}))
    end)

    assert {:error, {:http_error, 503, _}} = Bootstrap.fetch(retry: false)
  end
end
