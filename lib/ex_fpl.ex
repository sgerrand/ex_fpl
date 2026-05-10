defmodule ExFPL do
  @moduledoc """
  Elixir client for the unofficial
  [Fantasy Premier League](https://fantasy.premierleague.com/) public REST API.

  The API surface is split into resource modules that mirror the ExFPL API's nouns:

    * `ExFPL.Bootstrap` — global game data: players, teams, gameweeks
    * `ExFPL.Fixtures` — fixtures, optionally filtered to a gameweek
    * `ExFPL.Live` — live gameweek data
    * `ExFPL.Players` — per-player history and upcoming fixtures
    * `ExFPL.Entries` — manager/team data (summary, history, picks, my-team)
    * `ExFPL.Leagues.Classic` — classic league standings
    * `ExFPL.Leagues.H2H` — head-to-head league standings and matches

  Authenticated endpoints (`/me/`, `/my-team/{team_id}/`) require a session
  cookie obtained from a logged-in browser. See `ExFPL.Session` for details.

  ## Caching

  `ExFPL.Bootstrap.fetch/1` caches its (~1 MB) response in an ETS table for a
  default of one hour. Pass `cache: false` to bypass, or call
  `ExFPL.Cache.invalidate/0` to clear it.

  ## Returning raw responses

  Each fetch function accepts `raw: true` to return the decoded JSON body as a
  plain map (with string keys preserved as snake_case) rather than the struct
  representation. This is useful when you need access to fields that are not
  modelled as struct attributes.
  """
end
