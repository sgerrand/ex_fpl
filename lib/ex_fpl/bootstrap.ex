defmodule ExFPL.Bootstrap do
  @moduledoc """
  Fetch the global game snapshot from `/bootstrap-static/`.

  The response is large (~1 MB) and changes infrequently within a gameweek.
  By default it is cached in the application-supervised `ExFPL.Cache` ETS
  table for one hour. Pass `cache: false` to bypass; pass `raw: true` to
  receive the original JSON-decoded map instead of an `ExFPL.Snapshot` struct.
  """

  alias ExFPL.{Cache, HTTP, Snapshot}

  @cache_key {:bootstrap_static, :default}

  @type fetch_opts :: [cache: boolean(), raw: boolean()] | keyword()

  @doc "Fetch the bootstrap snapshot."
  @spec fetch(fetch_opts()) :: {:ok, Snapshot.t() | map()} | {:error, term()}
  def fetch(opts \\ []) do
    {use_cache, opts} = Keyword.pop(opts, :cache, true)
    {raw, opts} = Keyword.pop(opts, :raw, false)
    key = cache_key(raw)

    case use_cache && Cache.get(key) do
      {:ok, value} ->
        {:ok, value}

      _ ->
        with {:ok, body} <- HTTP.get("/bootstrap-static/", opts) do
          value = if raw, do: body, else: Snapshot.from_api(body)
          if use_cache, do: Cache.put(key, value)
          {:ok, value}
        end
    end
  end

  defp cache_key(false), do: @cache_key
  defp cache_key(true), do: {:bootstrap_static, :raw}
end
