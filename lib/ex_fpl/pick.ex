defmodule ExFPL.Pick do
  @moduledoc "A single pick within an entry's gameweek lineup."

  alias ExFPL.Decode

  @type t :: %__MODULE__{
          element: integer(),
          position: integer(),
          multiplier: integer(),
          is_captain: boolean(),
          is_vice_captain: boolean()
        }

  defstruct [:element, :position, :multiplier, :is_captain, :is_vice_captain]

  @fields [:element, :position, :multiplier, :is_captain, :is_vice_captain]

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data), do: Decode.cast(__MODULE__, @fields, data)
end
