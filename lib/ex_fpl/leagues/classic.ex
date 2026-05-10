defmodule ExFPL.Leagues.Classic do
  @moduledoc "Fetch classic-league standings from `/leagues-classic/{league_id}/standings/`."

  alias ExFPL.{ClassicStandings, HTTP}

  @doc """
  Fetch one page of classic-league standings.

  Pass `page: N` (default `1`) to paginate; ExFPL returns 50 entries per page.
  Pass `raw: true` to receive the raw JSON-decoded map.
  """
  @spec standings(integer(), keyword()) ::
          {:ok, ClassicStandings.t() | map()} | {:error, term()}
  def standings(league_id, opts \\ []) when is_integer(league_id) do
    {page, opts} = Keyword.pop(opts, :page, 1)
    {raw, opts} = Keyword.pop(opts, :raw, false)
    opts = Keyword.put(opts, :params, page_standings: page)

    with {:ok, body} <- HTTP.get("/leagues-classic/#{league_id}/standings/", opts) do
      if raw do
        {:ok, body}
      else
        {:ok, ClassicStandings.from_api(body)}
      end
    end
  end
end
