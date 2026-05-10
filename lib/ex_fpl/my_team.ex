defmodule ExFPL.MyTeam do
  @moduledoc """
  Decoded `/my-team/{team_id}/` response — the authenticated user's current
  team selection, chip status, and pending transfer information.

  This is an authenticated endpoint; see `ExFPL.Session`.
  """

  @type t :: %__MODULE__{
          picks: [ExFPL.Pick.t()],
          chips: [map()],
          transfers: map() | nil
        }

  defstruct picks: [], chips: [], transfers: nil

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data) when is_map(data) do
    %__MODULE__{
      picks: Enum.map(Map.get(data, "picks", []), &ExFPL.Pick.from_api/1),
      chips: Map.get(data, "chips", []),
      transfers: Map.get(data, "transfers")
    }
  end
end
