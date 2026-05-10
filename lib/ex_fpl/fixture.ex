defmodule ExFPL.Fixture do
  @moduledoc "A match fixture as returned by `/fixtures/`."

  alias ExFPL.Decode

  @type t :: %__MODULE__{
          id: integer(),
          code: integer(),
          event: integer() | nil,
          team_h: integer(),
          team_a: integer(),
          team_h_score: integer() | nil,
          team_a_score: integer() | nil,
          team_h_difficulty: integer(),
          team_a_difficulty: integer(),
          kickoff_time: String.t() | nil,
          started: boolean() | nil,
          finished: boolean(),
          finished_provisional: boolean(),
          minutes: integer(),
          pulse_id: integer(),
          stats: list()
        }

  defstruct [
    :id,
    :code,
    :event,
    :team_h,
    :team_a,
    :team_h_score,
    :team_a_score,
    :team_h_difficulty,
    :team_a_difficulty,
    :kickoff_time,
    :started,
    :finished,
    :finished_provisional,
    :minutes,
    :pulse_id,
    :stats
  ]

  @fields [
    :id,
    :code,
    :event,
    :team_h,
    :team_a,
    :team_h_score,
    :team_a_score,
    :team_h_difficulty,
    :team_a_difficulty,
    :kickoff_time,
    :started,
    :finished,
    :finished_provisional,
    :minutes,
    :pulse_id,
    :stats
  ]

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data), do: Decode.cast(__MODULE__, @fields, data)
end
