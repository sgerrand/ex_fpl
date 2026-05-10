defmodule ExFPL.Picks do
  @moduledoc "Decoded `/entry/{team_id}/event/{gw}/picks/` response."

  @type t :: %__MODULE__{
          active_chip: String.t() | nil,
          automatic_subs: [map()],
          entry_history: map() | nil,
          picks: [ExFPL.Pick.t()]
        }

  defstruct active_chip: nil, automatic_subs: [], entry_history: nil, picks: []

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data) when is_map(data) do
    %__MODULE__{
      active_chip: Map.get(data, "active_chip"),
      automatic_subs: Map.get(data, "automatic_subs", []),
      entry_history: Map.get(data, "entry_history"),
      picks: Enum.map(Map.get(data, "picks", []), &ExFPL.Pick.from_api/1)
    }
  end
end
