defmodule ExFPL.StructsTest do
  @moduledoc """
  Tests for the `from_api/1` decoders on each data struct module. Kept in
  one file because the decoders are mechanical and share a fixture surface.
  """
  use ExUnit.Case, async: true

  import ExFPL.TestFixtures

  test "ExFPL.Team.from_api/1 maps fields" do
    assert %ExFPL.Team{id: 1, name: "Arsenal", short_name: "ARS", strength: 4, pulse_id: 1} =
             ExFPL.Team.from_api(team())
  end

  test "ExFPL.Player.from_api/1 renames `team` to `team_id`" do
    p = ExFPL.Player.from_api(player())
    assert p.id == 1
    assert p.web_name == "Saka"
    assert p.team_id == 1
    assert p.element_type == 3
    assert p.now_cost == 95
    assert p.in_dreamteam == false
  end

  test "ExFPL.Event.from_api/1 maps fields" do
    e = ExFPL.Event.from_api(event())
    assert e.id == 1
    assert e.name == "Gameweek 1"
    assert e.finished == true
    assert e.average_entry_score == 50
  end

  test "ExFPL.Fixture.from_api/1 maps fields" do
    f = ExFPL.Fixture.from_api(fixture())
    assert f.id == 1
    assert f.team_h == 1
    assert f.team_a == 2
    assert f.team_h_score == 2
    assert f.team_h_difficulty == 3
    assert f.stats == []
  end

  test "ExFPL.Snapshot.from_api/1 maps nested lists" do
    snap = ExFPL.Snapshot.from_api(bootstrap())
    assert [%ExFPL.Event{}] = snap.events
    assert [%ExFPL.Team{}] = snap.teams
    assert [%ExFPL.Player{}] = snap.players
    assert snap.total_players == 9_000_000
  end

  test "ExFPL.Snapshot.from_api/1 tolerates missing keys" do
    assert %ExFPL.Snapshot{events: [], teams: [], players: [], total_players: 0} =
             ExFPL.Snapshot.from_api(%{})
  end

  test "ExFPL.PlayerSummary.from_api/1 preserves nested maps" do
    s = ExFPL.PlayerSummary.from_api(player_summary())
    assert [%{"id" => 99}] = s.fixtures
    assert [%{"total_points" => 6}] = s.history
    assert [%{"total_points" => 200}] = s.history_past
  end

  test "ExFPL.PlayerSummary.from_api/1 tolerates missing keys" do
    assert %ExFPL.PlayerSummary{fixtures: [], history: [], history_past: []} =
             ExFPL.PlayerSummary.from_api(%{})
  end

  test "ExFPL.Entry.from_api/1 maps fields" do
    e = ExFPL.Entry.from_api(entry())
    assert e.id == 12_345
    assert e.name == "My Team"
    assert e.player_first_name == "Jane"
    assert e.summary_overall_points == 1500
    assert is_map(e.leagues)
  end

  test "ExFPL.EntryHistory.from_api/1 maps lists" do
    h = ExFPL.EntryHistory.from_api(entry_history())
    assert [%{"event" => 1}] = h.current
    assert [%{"season_name" => "2024/25"}] = h.past
    assert [%{"name" => "wildcard"}] = h.chips
  end

  test "ExFPL.EntryHistory.from_api/1 tolerates missing keys" do
    assert %ExFPL.EntryHistory{current: [], past: [], chips: []} =
             ExFPL.EntryHistory.from_api(%{})
  end

  test "ExFPL.Pick.from_api/1 maps fields" do
    pick =
      ExFPL.Pick.from_api(%{
        "element" => 1,
        "position" => 2,
        "multiplier" => 1,
        "is_captain" => false,
        "is_vice_captain" => true
      })

    assert pick.element == 1
    assert pick.position == 2
    assert pick.is_vice_captain == true
  end

  test "ExFPL.Picks.from_api/1 decodes nested picks" do
    p = ExFPL.Picks.from_api(picks())
    assert p.active_chip == nil
    assert [%ExFPL.Pick{element: 1, is_captain: true}] = p.picks
  end

  test "ExFPL.Picks.from_api/1 tolerates missing keys" do
    assert %ExFPL.Picks{active_chip: nil, automatic_subs: [], entry_history: nil, picks: []} =
             ExFPL.Picks.from_api(%{})
  end

  test "ExFPL.ClassicStandings.from_api/1 decodes nested standings" do
    s = ExFPL.ClassicStandings.from_api(classic_standings())
    assert s.has_next == false
    assert s.page == 1
    assert [%ExFPL.ClassicStandings.Standing{rank: 1, total: 1500}] = s.standings
    assert [%{"entry" => 1}] = s.new_entries
  end

  test "ExFPL.ClassicStandings.from_api/1 tolerates missing keys" do
    assert %ExFPL.ClassicStandings{league: %{}, page: 1, standings: []} =
             ExFPL.ClassicStandings.from_api(%{})
  end

  test "ExFPL.ClassicStandings.Standing.from_api/1 maps fields" do
    raw = classic_standings()["standings"]["results"] |> hd()
    s = ExFPL.ClassicStandings.Standing.from_api(raw)
    assert s.rank == 1
    assert s.entry_name == "My Team"
  end

  test "ExFPL.H2HStandings.from_api/1 decodes nested standings" do
    s = ExFPL.H2HStandings.from_api(h2h_standings())
    assert [%ExFPL.H2HStandings.Standing{matches_won: 4, points_for: 240}] = s.standings
  end

  test "ExFPL.H2HStandings.from_api/1 tolerates missing keys" do
    assert %ExFPL.H2HStandings{standings: []} = ExFPL.H2HStandings.from_api(%{})
  end

  test "ExFPL.H2HStandings.Standing.from_api/1 maps fields" do
    raw = h2h_standings()["standings"]["results"] |> hd()
    s = ExFPL.H2HStandings.Standing.from_api(raw)
    assert s.matches_played == 4
    assert s.points_for == 240
  end

  test "ExFPL.H2HMatch.from_api/1 maps fields" do
    m = ExFPL.H2HMatch.from_api(h2h_match())
    assert m.event == 1
    assert m.entry_1_points == 60
    assert m.entry_2_points == 50
    assert m.is_knockout == false
  end

  test "ExFPL.LiveSnapshot.from_api/1 preserves elements" do
    s = ExFPL.LiveSnapshot.from_api(live())
    assert [%{"id" => 1}] = s.elements
  end

  test "ExFPL.LiveSnapshot.from_api/1 tolerates missing keys" do
    assert %ExFPL.LiveSnapshot{elements: []} = ExFPL.LiveSnapshot.from_api(%{})
  end

  test "ExFPL.Me.from_api/1 maps fields" do
    m = ExFPL.Me.from_api(me())
    assert m.player["entry"] == 12_345
    assert m.watched == [1, 2, 3]
  end

  test "ExFPL.Me.from_api/1 tolerates missing keys" do
    assert %ExFPL.Me{player: nil, watched: []} = ExFPL.Me.from_api(%{})
  end

  test "ExFPL.MyTeam.from_api/1 decodes picks" do
    t = ExFPL.MyTeam.from_api(my_team())
    assert [%ExFPL.Pick{element: 1}] = t.picks
    assert is_list(t.chips)
    assert is_map(t.transfers)
  end

  test "ExFPL.MyTeam.from_api/1 tolerates missing keys" do
    assert %ExFPL.MyTeam{picks: [], chips: [], transfers: nil} = ExFPL.MyTeam.from_api(%{})
  end
end
