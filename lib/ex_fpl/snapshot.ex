defmodule ExFPL.Snapshot do
  @moduledoc """
  Decoded `/bootstrap-static/` response: the global ExFPL snapshot.

  Contains the lists of teams, players (`elements` in the raw payload),
  events (gameweeks), plus the registered player count.
  """

  @type t :: %__MODULE__{
          events: [ExFPL.Event.t()],
          teams: [ExFPL.Team.t()],
          players: [ExFPL.Player.t()],
          total_players: integer()
        }

  defstruct events: [], teams: [], players: [], total_players: 0

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data) when is_map(data) do
    %__MODULE__{
      events: Enum.map(Map.get(data, "events", []), &ExFPL.Event.from_api/1),
      teams: Enum.map(Map.get(data, "teams", []), &ExFPL.Team.from_api/1),
      players: Enum.map(Map.get(data, "elements", []), &ExFPL.Player.from_api/1),
      total_players: Map.get(data, "total_players", 0)
    }
  end
end
