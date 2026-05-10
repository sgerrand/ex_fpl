defmodule ExFPL.PlayerSummary do
  @moduledoc """
  Decoded `/element-summary/{player_id}/` response.

  `fixtures` is a list of upcoming fixtures, `history` is the per-gameweek
  history for the current season, and `history_past` summarises previous
  seasons. Items in each list are plain maps with the API's original
  string keys preserved.
  """

  @type t :: %__MODULE__{
          fixtures: [map()],
          history: [map()],
          history_past: [map()]
        }

  defstruct fixtures: [], history: [], history_past: []

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data) when is_map(data) do
    %__MODULE__{
      fixtures: Map.get(data, "fixtures", []),
      history: Map.get(data, "history", []),
      history_past: Map.get(data, "history_past", [])
    }
  end
end
