defmodule ExFPL.Team do
  @moduledoc "A Premier League team as returned by the ExFPL API."

  alias ExFPL.Decode

  @type t :: %__MODULE__{
          id: integer(),
          code: integer(),
          name: String.t(),
          short_name: String.t(),
          played: integer(),
          win: integer(),
          draw: integer(),
          loss: integer(),
          points: integer(),
          position: integer(),
          form: String.t() | nil,
          strength: integer(),
          strength_overall_home: integer(),
          strength_overall_away: integer(),
          strength_attack_home: integer(),
          strength_attack_away: integer(),
          strength_defence_home: integer(),
          strength_defence_away: integer(),
          pulse_id: integer()
        }

  defstruct [
    :id,
    :code,
    :name,
    :short_name,
    :played,
    :win,
    :draw,
    :loss,
    :points,
    :position,
    :form,
    :strength,
    :strength_overall_home,
    :strength_overall_away,
    :strength_attack_home,
    :strength_attack_away,
    :strength_defence_home,
    :strength_defence_away,
    :pulse_id
  ]

  @fields [
    :id,
    :code,
    :name,
    :short_name,
    :played,
    :win,
    :draw,
    :loss,
    :points,
    :position,
    :form,
    :strength,
    :strength_overall_home,
    :strength_overall_away,
    :strength_attack_home,
    :strength_attack_away,
    :strength_defence_home,
    :strength_defence_away,
    :pulse_id
  ]

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data), do: Decode.cast(__MODULE__, @fields, data)
end
