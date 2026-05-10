defmodule ExFPL.EntryHistory do
  @moduledoc """
  Decoded `/entry/{team_id}/history/` response.

  `current` lists per-gameweek scores for the active season, `past` lists
  prior season finishes and `chips` records chips played. Items are plain
  maps with the API's original string keys.
  """

  @type t :: %__MODULE__{
          current: [map()],
          past: [map()],
          chips: [map()]
        }

  defstruct current: [], past: [], chips: []

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data) when is_map(data) do
    %__MODULE__{
      current: Map.get(data, "current", []),
      past: Map.get(data, "past", []),
      chips: Map.get(data, "chips", [])
    }
  end
end
