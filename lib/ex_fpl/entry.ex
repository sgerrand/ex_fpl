defmodule ExFPL.Entry do
  @moduledoc "An ExFPL manager / team summary as returned by `/entry/{team_id}/`."

  alias ExFPL.Decode

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          player_first_name: String.t(),
          player_last_name: String.t(),
          summary_overall_points: integer() | nil,
          summary_overall_rank: integer() | nil,
          summary_event_points: integer() | nil,
          summary_event_rank: integer() | nil,
          current_event: integer() | nil,
          started_event: integer(),
          joined_time: String.t(),
          favourite_team: integer() | nil,
          player_region_id: integer() | nil,
          player_region_name: String.t() | nil,
          last_deadline_bank: integer() | nil,
          last_deadline_value: integer() | nil,
          last_deadline_total_transfers: integer() | nil,
          kit: String.t() | nil,
          leagues: map() | nil
        }

  defstruct [
    :id,
    :name,
    :player_first_name,
    :player_last_name,
    :summary_overall_points,
    :summary_overall_rank,
    :summary_event_points,
    :summary_event_rank,
    :current_event,
    :started_event,
    :joined_time,
    :favourite_team,
    :player_region_id,
    :player_region_name,
    :last_deadline_bank,
    :last_deadline_value,
    :last_deadline_total_transfers,
    :kit,
    :leagues
  ]

  @fields [
    :id,
    :name,
    :player_first_name,
    :player_last_name,
    :summary_overall_points,
    :summary_overall_rank,
    :summary_event_points,
    :summary_event_rank,
    :current_event,
    :started_event,
    :joined_time,
    :favourite_team,
    :player_region_id,
    :player_region_name,
    :last_deadline_bank,
    :last_deadline_value,
    :last_deadline_total_transfers,
    :kit,
    :leagues
  ]

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data), do: Decode.cast(__MODULE__, @fields, data)
end
