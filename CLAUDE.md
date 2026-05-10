# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- `mix deps.get` — install dependencies
- `mix test` — run the full test suite
- `mix test test/ex_fpl/bootstrap_test.exs` — run a single test file
- `mix test test/ex_fpl/bootstrap_test.exs:42` — run a single test by line
- `mix format` — format all sources (uses `.formatter.exs`)
- `mix coveralls` / `mix coveralls.html` — test coverage (envs preset in `mix.exs`)
- `mix docs` — generate ExDoc HTML into `doc/`

Elixir requirement: `~> 1.19` (see `mix.exs`).

## Architecture

ExFPL is a thin Elixir client around the unofficial Fantasy Premier League REST API at `https://fantasy.premierleague.com/api`. The codebase has three layers:

**HTTP layer (`ExFPL.HTTP`).** All requests funnel through `HTTP.get/2`, which prepends the base URL, sets `retry: :safe_transient`, attaches a `cookie` header when a `%ExFPL.Session{}` is passed, merges `Application.get_env(:ex_fpl, :req_options, [])` (the test suite injects `plug: {Req.Test, ExFPL.HTTPStub}` here), forwards extra opts to `Req.request/1`, and emits a `[:fpl, :http, :request]` telemetry event. Library code must not call `Req` directly — going through this module is what makes test stubbing and telemetry uniform.

**Resource modules (`lib/ex_fpl/*.ex`, plus `leagues/`).** One module per API resource (`Bootstrap`, `Fixtures`, `Live`, `Players`, `Entries`, `Leagues.Classic`, `Leagues.H2H`). Each fetch function:
1. Pops `raw` (and resource-specific options like `:cache`) off the keyword list.
2. Calls `HTTP.get/2` with the remaining opts (forwarded to `Req`).
3. On success, returns `{:ok, struct}` by default or `{:ok, raw_map}` when `raw: true`.

The `raw: true` escape hatch is contractual — every fetch function honours it so callers can access fields not modelled on the struct.

**Struct decoding (`ExFPL.Decode` + per-struct `from_api/1`).** Each struct module defines a `defstruct`, a `@type t`, and a `from_api/1` constructor. `Decode.cast/3` and `Decode.cast_list/3` map string-keyed JSON into struct fields; pass `{field, "source_key"}` tuples for renames (e.g. API's `elements` → struct's `players`). Nested collections are decoded by mapping each element through its own `from_api/1`.

**Authenticated endpoints.** `/me/` and `/my-team/{id}/` require `session: %ExFPL.Session{}`. `ExFPL.Entries.me/1` and `my_team/2` call `require_session!/1` which raises `ArgumentError` when missing. Sessions wrap a raw cookie string copied from a logged-in browser; this library does not implement the login flow.

**Caching (`ExFPL.Cache`).** A GenServer-supervised, named ETS table (`:ex_fpl_cache`) with per-entry TTL. Started by `ExFPL.Application` so the table is always available while the app runs. Currently used only by `Bootstrap.fetch/1` (default 1 hour TTL, separate keys for raw vs struct values). `cache: false` bypasses; `Cache.invalidate/0` clears all entries.

## Testing conventions

`test/test_helper.exs` sets `:req_options` to route every request through `Req.Test` with the `ExFPL.HTTPStub` name. Tests then call `Req.Test.stub(ExFPL.HTTPStub, fn conn -> Req.Test.json(conn, body) end)` (or the `ExFPL.TestFixtures.stub_json/1` helper) to control responses. `test/support/fixtures.ex` provides realistic JSON shapes for every resource — prefer reusing those over hand-rolling payloads. `elixirc_paths` includes `test/support` only in the `:test` env.

When testing `Bootstrap` (or anything that hits the cache), pass `cache: false` or call `ExFPL.Cache.invalidate/0` in setup to avoid cross-test contamination.
