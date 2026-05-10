# credo:disable-for-this-file Credo.Check.Warning.StructFieldAmount
defmodule ExFPL.Player do
  @moduledoc """
  A player ("element" in ExFPL parlance) as returned by `/bootstrap-static/`.

  `team_id` is the ExFPL team integer; cross-reference against the `:teams`
  field of `t:ExFPL.Snapshot.t/0` to look up the team. `element_type` is the
  position code (1=GK, 2=DEF, 3=MID, 4=FWD).
  """

  alias ExFPL.Decode

  @type t :: %__MODULE__{
          id: integer(),
          code: integer(),
          web_name: String.t(),
          first_name: String.t(),
          second_name: String.t(),
          team_id: integer(),
          element_type: integer(),
          now_cost: integer(),
          total_points: integer(),
          status: String.t(),
          form: String.t(),
          points_per_game: String.t(),
          selected_by_percent: String.t(),
          minutes: integer(),
          goals_scored: integer(),
          assists: integer(),
          clean_sheets: integer(),
          goals_conceded: integer(),
          own_goals: integer(),
          penalties_saved: integer(),
          penalties_missed: integer(),
          yellow_cards: integer(),
          red_cards: integer(),
          saves: integer(),
          bonus: integer(),
          bps: integer(),
          influence: String.t(),
          creativity: String.t(),
          threat: String.t(),
          ict_index: String.t(),
          expected_goals: String.t() | nil,
          expected_assists: String.t() | nil,
          news: String.t() | nil,
          chance_of_playing_this_round: integer() | nil,
          chance_of_playing_next_round: integer() | nil,
          in_dreamteam: boolean(),
          ep_next: String.t() | nil,
          ep_this: String.t() | nil
        }

  defstruct [
    :id,
    :code,
    :web_name,
    :first_name,
    :second_name,
    :team_id,
    :element_type,
    :now_cost,
    :total_points,
    :status,
    :form,
    :points_per_game,
    :selected_by_percent,
    :minutes,
    :goals_scored,
    :assists,
    :clean_sheets,
    :goals_conceded,
    :own_goals,
    :penalties_saved,
    :penalties_missed,
    :yellow_cards,
    :red_cards,
    :saves,
    :bonus,
    :bps,
    :influence,
    :creativity,
    :threat,
    :ict_index,
    :expected_goals,
    :expected_assists,
    :news,
    :chance_of_playing_this_round,
    :chance_of_playing_next_round,
    :in_dreamteam,
    :ep_next,
    :ep_this
  ]

  @fields [
    :id,
    :code,
    :web_name,
    :first_name,
    :second_name,
    {:team_id, "team"},
    :element_type,
    :now_cost,
    :total_points,
    :status,
    :form,
    :points_per_game,
    :selected_by_percent,
    :minutes,
    :goals_scored,
    :assists,
    :clean_sheets,
    :goals_conceded,
    :own_goals,
    :penalties_saved,
    :penalties_missed,
    :yellow_cards,
    :red_cards,
    :saves,
    :bonus,
    :bps,
    :influence,
    :creativity,
    :threat,
    :ict_index,
    :expected_goals,
    :expected_assists,
    :news,
    :chance_of_playing_this_round,
    :chance_of_playing_next_round,
    :in_dreamteam,
    :ep_next,
    :ep_this
  ]

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data), do: Decode.cast(__MODULE__, @fields, data)
end
