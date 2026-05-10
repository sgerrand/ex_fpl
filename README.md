# ExFPL

Elixir client for the unofficial [Fantasy Premier
League](https://fantasy.premierleague.com/) public REST API.

## Installation

Add `:ex_fpl` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_fpl, "~> 0.1.0"}
  ]
end
```

## Quick start

```elixir
# Bootstrap snapshot — players, teams, gameweeks. Cached in ETS for 1 hour.
{:ok, snapshot} = ExFPL.Bootstrap.fetch()
%ExFPL.Snapshot{teams: teams, players: players, events: events} = snapshot

# All fixtures, or just one gameweek's
{:ok, fixtures} = ExFPL.Fixtures.list()
{:ok, gw1}      = ExFPL.Fixtures.list(event: 1)

# Live gameweek data
{:ok, %ExFPL.LiveSnapshot{}} = ExFPL.Live.fetch(1)

# Per-player history and upcoming
{:ok, %ExFPL.PlayerSummary{}} = ExFPL.Players.summary(player_id)

# Manager / entry data
{:ok, %ExFPL.Entry{}}        = ExFPL.Entries.get(team_id)
{:ok, %ExFPL.EntryHistory{}} = ExFPL.Entries.history(team_id)
{:ok, %ExFPL.Picks{}}        = ExFPL.Entries.picks(team_id, gameweek)

# Classic and H2H league standings
{:ok, %ExFPL.ClassicStandings{}} = ExFPL.Leagues.Classic.standings(314)
{:ok, %ExFPL.ClassicStandings{}} = ExFPL.Leagues.Classic.standings(314, page: 2)

{:ok, %ExFPL.H2HStandings{}}     = ExFPL.Leagues.H2H.standings(999)
{:ok, h2h_matches}             = ExFPL.Leagues.H2H.matches(999, event: 5)
```

## Resource modules

| Module | Endpoint | Returns |
|---|---|---|
| `ExFPL.Bootstrap` | `/bootstrap-static/` | `ExFPL.Snapshot` |
| `ExFPL.Fixtures` | `/fixtures/` | `[ExFPL.Fixture]` |
| `ExFPL.Live` | `/event/{id}/live/` | `ExFPL.LiveSnapshot` |
| `ExFPL.Players` | `/element-summary/{id}/` | `ExFPL.PlayerSummary` |
| `ExFPL.Entries` | `/entry/{id}/`, `/history/`, `/picks/`, `/me/`, `/my-team/{id}/` | `ExFPL.Entry`, `ExFPL.EntryHistory`, `ExFPL.Picks`, `ExFPL.Me`, `ExFPL.MyTeam` |
| `ExFPL.Leagues.Classic` | `/leagues-classic/{id}/standings/` | `ExFPL.ClassicStandings` |
| `ExFPL.Leagues.H2H` | `/leagues-h2h/{id}/standings/`, `/leagues-h2h-matches/league/{id}/` | `ExFPL.H2HStandings`, `[ExFPL.H2HMatch]` |

Every fetch function accepts:

- `raw: true` — return the raw JSON-decoded map (string keys preserved) instead
  of the struct, useful when you need fields not modelled on the struct.
- Any other key is forwarded to `Req` (e.g. `retry: false`, `receive_timeout:
  30_000`).

## Caching

`ExFPL.Bootstrap.fetch/1` caches its (~1 MB) response in an application-supervised
ETS table for one hour. Pass `cache: false` to bypass the cache; call
`ExFPL.Cache.invalidate/0` to clear it.

```elixir
ExFPL.Bootstrap.fetch()                # cache hit on second call
ExFPL.Bootstrap.fetch(cache: false)    # always fetches
ExFPL.Cache.invalidate()               # clear the cache
```

## Authenticated endpoints

`/me/` and `/my-team/{team_id}/` require a session cookie obtained from a
logged-in browser. This library does not implement the login flow itself —
construct an `ExFPL.Session` from the cookie value:

```elixir
session = ExFPL.Session.new(cookie: "pl_profile=...; sessionid=...")
{:ok, %ExFPL.Me{}}     = ExFPL.Entries.me(session: session)
{:ok, %ExFPL.MyTeam{}} = ExFPL.Entries.my_team(team_id, session: session)
```

Calling these without a session raises `ArgumentError`.

## Telemetry

Each HTTP request emits a `[:fpl, :http, :request]` telemetry event with
`%{duration: native_time}` and `%{path: path, result: :ok | :error}`.

```elixir
:telemetry.attach("fpl-logger", [:fpl, :http, :request], &MyApp.handle/4, nil)
```

## Testing

Tests stub the network with [`Req.Test`](https://hexdocs.pm/req/Req.Test.html).
Configure your tests to use the stub plug:

```elixir
# test/test_helper.exs
Application.put_env(:ex_fpl, :req_options, plug: {Req.Test, ExFPL.HTTPStub})
ExUnit.start()
```

Then in any test:

```elixir
Req.Test.stub(ExFPL.HTTPStub, fn conn ->
  Req.Test.json(conn, %{"teams" => [...], "elements" => [...]})
end)

{:ok, %ExFPL.Snapshot{}} = ExFPL.Bootstrap.fetch(cache: false)
```

## Documentation

Documentation is generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm/ex_fpl).
