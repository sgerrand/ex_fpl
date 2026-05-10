defmodule ExFPL.H2HMatch do
  @moduledoc "A single head-to-head match between two entries in a gameweek."

  alias ExFPL.Decode

  @type t :: %__MODULE__{
          id: integer(),
          event: integer(),
          finished: boolean(),
          tiebreak: String.t() | nil,
          winner: integer() | nil,
          seed_value: integer() | nil,
          is_knockout: boolean(),
          entry_1_entry: integer() | nil,
          entry_1_name: String.t() | nil,
          entry_1_player_name: String.t() | nil,
          entry_1_points: integer(),
          entry_1_win: integer(),
          entry_1_draw: integer(),
          entry_1_loss: integer(),
          entry_1_total: integer(),
          entry_2_entry: integer() | nil,
          entry_2_name: String.t() | nil,
          entry_2_player_name: String.t() | nil,
          entry_2_points: integer(),
          entry_2_win: integer(),
          entry_2_draw: integer(),
          entry_2_loss: integer(),
          entry_2_total: integer()
        }

  defstruct [
    :id,
    :event,
    :finished,
    :tiebreak,
    :winner,
    :seed_value,
    :is_knockout,
    :entry_1_entry,
    :entry_1_name,
    :entry_1_player_name,
    :entry_1_points,
    :entry_1_win,
    :entry_1_draw,
    :entry_1_loss,
    :entry_1_total,
    :entry_2_entry,
    :entry_2_name,
    :entry_2_player_name,
    :entry_2_points,
    :entry_2_win,
    :entry_2_draw,
    :entry_2_loss,
    :entry_2_total
  ]

  @fields [
    :id,
    :event,
    :finished,
    :tiebreak,
    :winner,
    :seed_value,
    :is_knockout,
    :entry_1_entry,
    :entry_1_name,
    :entry_1_player_name,
    :entry_1_points,
    :entry_1_win,
    :entry_1_draw,
    :entry_1_loss,
    :entry_1_total,
    :entry_2_entry,
    :entry_2_name,
    :entry_2_player_name,
    :entry_2_points,
    :entry_2_win,
    :entry_2_draw,
    :entry_2_loss,
    :entry_2_total
  ]

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data), do: Decode.cast(__MODULE__, @fields, data)
end
