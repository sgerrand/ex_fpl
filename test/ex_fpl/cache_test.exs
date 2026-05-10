defmodule ExFPL.CacheTest do
  use ExUnit.Case, async: false

  alias ExFPL.Cache

  setup do
    Cache.invalidate(:all)
    :ok
  end

  test "miss on empty key" do
    assert Cache.get(:nope) == :miss
  end

  test "put then get returns the value" do
    Cache.put(:k, 42)
    assert Cache.get(:k) == {:ok, 42}
  end

  test "expired entries are evicted on read" do
    # negative ttl means already expired
    Cache.put(:expired, "old", -1_000)
    assert Cache.get(:expired) == :miss
    # confirm the row was actually removed
    assert :ets.lookup(:ex_fpl_cache, :expired) == []
  end

  test "invalidate(:all) clears the table" do
    Cache.put(:a, 1)
    Cache.put(:b, 2)
    Cache.invalidate(:all)
    assert Cache.get(:a) == :miss
    assert Cache.get(:b) == :miss
  end

  test "invalidate/0 defaults to :all" do
    Cache.put(:x, 1)
    Cache.invalidate()
    assert Cache.get(:x) == :miss
  end

  test "invalidate(key) clears a single entry" do
    Cache.put(:keep, 1)
    Cache.put(:drop, 2)
    Cache.invalidate(:drop)
    assert Cache.get(:keep) == {:ok, 1}
    assert Cache.get(:drop) == :miss
  end

  test "default ttl applies when not specified" do
    Cache.put(:default, "v")
    assert Cache.get(:default) == {:ok, "v"}
  end

  test "start_link returns already_started when supervised" do
    assert {:error, {:already_started, _pid}} = Cache.start_link()
  end
end
