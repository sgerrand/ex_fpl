defmodule ExFPL.Leagues.H2H do
  @moduledoc """
  Fetch head-to-head league data.

  Standings come from `/leagues-h2h/{league_id}/standings/` and per-gameweek
  matches from `/leagues-h2h-matches/league/{league_id}/`.
  """

  alias ExFPL.{H2HMatch, H2HStandings, HTTP}

  @doc """
  Fetch one page of H2H league standings.

  Pass `page: N` to paginate. Pass `raw: true` to receive the raw map.
  """
  @spec standings(integer(), keyword()) :: {:ok, H2HStandings.t() | map()} | {:error, term()}
  def standings(league_id, opts \\ []) when is_integer(league_id) do
    {page, opts} = Keyword.pop(opts, :page, 1)
    {raw, opts} = Keyword.pop(opts, :raw, false)
    opts = Keyword.put(opts, :params, page_standings: page)

    with {:ok, body} <- HTTP.get("/leagues-h2h/#{league_id}/standings/", opts) do
      if raw do
        {:ok, body}
      else
        {:ok, H2HStandings.from_api(body)}
      end
    end
  end

  @doc """
  Fetch H2H matches for a league.

  Pass `event: gw` to restrict to a gameweek and `page: N` to paginate. Pass
  `raw: true` to receive the raw map.
  """
  @spec matches(integer(), keyword()) ::
          {:ok, [H2HMatch.t()] | map()} | {:error, term()}
  def matches(league_id, opts \\ []) when is_integer(league_id) do
    {event, opts} = Keyword.pop(opts, :event)
    {page, opts} = Keyword.pop(opts, :page, 1)
    {raw, opts} = Keyword.pop(opts, :raw, false)

    params =
      [page: page]
      |> then(fn p -> if event, do: Keyword.put(p, :event, event), else: p end)

    opts = Keyword.put(opts, :params, params)

    with {:ok, body} <- HTTP.get("/leagues-h2h-matches/league/#{league_id}/", opts) do
      if raw do
        {:ok, body}
      else
        results = body |> Map.get("results", []) |> Enum.map(&H2HMatch.from_api/1)
        {:ok, results}
      end
    end
  end
end
