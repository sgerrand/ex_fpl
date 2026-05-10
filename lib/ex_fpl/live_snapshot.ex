defmodule ExFPL.LiveSnapshot do
  @moduledoc """
  Decoded `/event/{event_id}/live/` response.

  Each entry in `elements` is a plain map with the player's `id`, raw `stats`
  map and `explain` list of bonus-point breakdowns. String keys are preserved.
  """

  @type t :: %__MODULE__{
          elements: [map()]
        }

  defstruct elements: []

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data) when is_map(data) do
    %__MODULE__{
      elements: Map.get(data, "elements", [])
    }
  end
end
