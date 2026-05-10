defmodule ExFPL.Me do
  @moduledoc """
  Decoded `/me/` response — information about the authenticated ExFPL user.

  This is an authenticated endpoint; see `ExFPL.Session`.
  """

  @type t :: %__MODULE__{
          player: map() | nil,
          watched: [integer()]
        }

  defstruct player: nil, watched: []

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data) when is_map(data) do
    %__MODULE__{
      player: Map.get(data, "player"),
      watched: Map.get(data, "watched", [])
    }
  end
end
