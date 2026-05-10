defmodule ExFPL.Cache do
  @moduledoc """
  ETS-backed cache with per-entry TTL.

  Used by `ExFPL.Bootstrap.fetch/1` to avoid re-downloading the ~1 MB
  `bootstrap-static` payload on every call. Started under the application
  supervisor; the underlying ETS table is always available while the
  application is running.
  """

  use GenServer

  @table :ex_fpl_cache
  @default_ttl :timer.hours(1)

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc "Fetch a value from the cache. Returns `{:ok, value}` or `:miss`."
  @spec get(term()) :: {:ok, term()} | :miss
  def get(key) do
    case :ets.lookup(@table, key) do
      [{^key, value, expires_at}] ->
        if System.monotonic_time(:millisecond) < expires_at do
          {:ok, value}
        else
          :ets.delete(@table, key)
          :miss
        end

      [] ->
        :miss
    end
  end

  @doc "Insert a value with an optional TTL in milliseconds (default 1 hour)."
  @spec put(term(), term(), non_neg_integer()) :: :ok
  def put(key, value, ttl_ms \\ @default_ttl) do
    expires_at = System.monotonic_time(:millisecond) + ttl_ms
    :ets.insert(@table, {key, value, expires_at})
    :ok
  end

  @doc "Remove a single key, or all entries when called with `:all` (default)."
  @spec invalidate(term() | :all) :: :ok
  def invalidate(key \\ :all)

  def invalidate(:all) do
    :ets.delete_all_objects(@table)
    :ok
  end

  def invalidate(key) do
    :ets.delete(@table, key)
    :ok
  end

  @impl true
  def init(_opts) do
    :ets.new(@table, [:set, :public, :named_table, read_concurrency: true])
    {:ok, %{}}
  end
end
