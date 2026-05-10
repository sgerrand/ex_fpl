defmodule ExFPL.TestFixtures do
  @moduledoc false

  def team do
    %{
      "id" => 1,
      "code" => 3,
      "name" => "Arsenal",
      "short_name" => "ARS",
      "played" => 0,
      "win" => 0,
      "draw" => 0,
      "loss" => 0,
      "points" => 0,
      "position" => 0,
      "form" => nil,
      "strength" => 4,
      "strength_overall_home" => 1305,
      "strength_overall_away" => 1320,
      "strength_attack_home" => 1340,
      "strength_attack_away" => 1330,
      "strength_defence_home" => 1280,
      "strength_defence_away" => 1310,
      "pulse_id" => 1
    }
  end

  def player do
    %{
      "id" => 1,
      "code" => 200_000,
      "web_name" => "Saka",
      "first_name" => "Bukayo",
      "second_name" => "Saka",
      "team" => 1,
      "element_type" => 3,
      "now_cost" => 95,
      "total_points" => 12,
      "status" => "a",
      "form" => "6.0",
      "points_per_game" => "6.0",
      "selected_by_percent" => "45.0",
      "minutes" => 180,
      "goals_scored" => 1,
      "assists" => 1,
      "clean_sheets" => 1,
      "goals_conceded" => 1,
      "own_goals" => 0,
      "penalties_saved" => 0,
      "penalties_missed" => 0,
      "yellow_cards" => 0,
      "red_cards" => 0,
      "saves" => 0,
      "bonus" => 1,
      "bps" => 30,
      "influence" => "30.0",
      "creativity" => "20.0",
      "threat" => "40.0",
      "ict_index" => "9.0",
      "expected_goals" => "0.50",
      "expected_assists" => "0.30",
      "news" => "",
      "chance_of_playing_this_round" => 100,
      "chance_of_playing_next_round" => 100,
      "in_dreamteam" => false,
      "ep_next" => "5.5",
      "ep_this" => "5.5"
    }
  end

  def event do
    %{
      "id" => 1,
      "name" => "Gameweek 1",
      "deadline_time" => "2026-08-15T17:30:00Z",
      "average_entry_score" => 50,
      "finished" => true,
      "data_checked" => true,
      "highest_score" => 120,
      "is_previous" => false,
      "is_current" => false,
      "is_next" => false,
      "top_element" => 1,
      "transfers_made" => 0,
      "most_selected" => 1,
      "most_transferred_in" => 1,
      "most_captained" => 1,
      "most_vice_captained" => 1,
      "ranked_count" => 9_000_000
    }
  end

  def fixture do
    %{
      "id" => 1,
      "code" => 12_345,
      "event" => 1,
      "team_h" => 1,
      "team_a" => 2,
      "team_h_score" => 2,
      "team_a_score" => 1,
      "team_h_difficulty" => 3,
      "team_a_difficulty" => 4,
      "kickoff_time" => "2026-08-15T19:00:00Z",
      "started" => true,
      "finished" => true,
      "finished_provisional" => true,
      "minutes" => 90,
      "pulse_id" => 9999,
      "stats" => []
    }
  end

  def bootstrap do
    %{
      "events" => [event()],
      "teams" => [team()],
      "elements" => [player()],
      "total_players" => 9_000_000
    }
  end

  def player_summary do
    %{
      "fixtures" => [%{"id" => 99, "event" => 2}],
      "history" => [%{"element" => 1, "round" => 1, "total_points" => 6}],
      "history_past" => [%{"season_name" => "2024/25", "total_points" => 200}]
    }
  end

  def entry do
    %{
      "id" => 12_345,
      "name" => "My Team",
      "player_first_name" => "Jane",
      "player_last_name" => "Doe",
      "summary_overall_points" => 1500,
      "summary_overall_rank" => 100_000,
      "summary_event_points" => 60,
      "summary_event_rank" => 50_000,
      "current_event" => 10,
      "started_event" => 1,
      "joined_time" => "2026-08-01T10:00:00Z",
      "favourite_team" => 1,
      "player_region_id" => 14,
      "player_region_name" => "England",
      "last_deadline_bank" => 5,
      "last_deadline_value" => 1005,
      "last_deadline_total_transfers" => 9,
      "kit" => nil,
      "leagues" => %{"classic" => [], "h2h" => [], "cup" => nil}
    }
  end

  def entry_history do
    %{
      "current" => [%{"event" => 1, "points" => 60, "total_points" => 60}],
      "past" => [%{"season_name" => "2024/25", "total_points" => 2000, "rank" => 50_000}],
      "chips" => [%{"name" => "wildcard", "event" => 5}]
    }
  end

  def picks do
    %{
      "active_chip" => nil,
      "automatic_subs" => [],
      "entry_history" => %{"event" => 1, "points" => 60},
      "picks" => [
        %{
          "element" => 1,
          "position" => 1,
          "multiplier" => 2,
          "is_captain" => true,
          "is_vice_captain" => false
        }
      ]
    }
  end

  def classic_standings do
    %{
      "league" => %{"id" => 314, "name" => "Overall", "scoring" => "c"},
      "new_entries" => %{"results" => [%{"entry" => 1}]},
      "standings" => %{
        "has_next" => false,
        "page" => 1,
        "results" => [
          %{
            "id" => 1,
            "event_total" => 60,
            "player_name" => "Jane Doe",
            "rank" => 1,
            "last_rank" => 1,
            "rank_sort" => 1,
            "total" => 1500,
            "entry" => 12_345,
            "entry_name" => "My Team"
          }
        ]
      }
    }
  end

  def h2h_standings do
    %{
      "league" => %{"id" => 999, "name" => "H2H League", "scoring" => "h"},
      "standings" => %{
        "has_next" => false,
        "page" => 1,
        "results" => [
          %{
            "id" => 1,
            "division" => 1,
            "entry" => 12_345,
            "player_name" => "Jane Doe",
            "rank" => 1,
            "last_rank" => 1,
            "rank_sort" => 1,
            "total" => 12,
            "entry_name" => "My Team",
            "matches_played" => 4,
            "matches_won" => 4,
            "matches_drawn" => 0,
            "matches_lost" => 0,
            "points_for" => 240
          }
        ]
      }
    }
  end

  def h2h_match do
    %{
      "id" => 1,
      "event" => 1,
      "finished" => true,
      "tiebreak" => nil,
      "winner" => 12_345,
      "seed_value" => nil,
      "is_knockout" => false,
      "entry_1_entry" => 12_345,
      "entry_1_name" => "My Team",
      "entry_1_player_name" => "Jane",
      "entry_1_points" => 60,
      "entry_1_win" => 1,
      "entry_1_draw" => 0,
      "entry_1_loss" => 0,
      "entry_1_total" => 3,
      "entry_2_entry" => 67_890,
      "entry_2_name" => "Other",
      "entry_2_player_name" => "John",
      "entry_2_points" => 50,
      "entry_2_win" => 0,
      "entry_2_draw" => 0,
      "entry_2_loss" => 1,
      "entry_2_total" => 0
    }
  end

  def h2h_matches_response do
    %{"has_next" => false, "page" => 1, "results" => [h2h_match()]}
  end

  def live do
    %{
      "elements" => [
        %{
          "id" => 1,
          "stats" => %{"minutes" => 90, "goals_scored" => 1, "total_points" => 9},
          "explain" => []
        }
      ]
    }
  end

  def me do
    %{
      "player" => %{"entry" => 12_345, "id" => 1, "first_name" => "Jane"},
      "watched" => [1, 2, 3]
    }
  end

  def my_team do
    %{
      "picks" => [
        %{
          "element" => 1,
          "position" => 1,
          "multiplier" => 1,
          "is_captain" => false,
          "is_vice_captain" => false
        }
      ],
      "chips" => [%{"name" => "wildcard", "status_for_entry" => "available"}],
      "transfers" => %{"cost" => 0, "limit" => nil, "made" => 0, "bank" => 5, "value" => 1005}
    }
  end

  @doc "Stub the ExFPL.HTTPStub to return the given body for any request."
  def stub_json(body) do
    Req.Test.stub(ExFPL.HTTPStub, fn conn -> Req.Test.json(conn, body) end)
  end
end
