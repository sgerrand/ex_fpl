defmodule ExFPL.ClassicStandings do
  @moduledoc """
  Decoded `/leagues-classic/{league_id}/standings/` response.

  `league` describes the league itself; `standings` is the current page of
  ranked entries; `has_next` indicates whether further pages exist.
  """

  alias ExFPL.Decode

  defmodule Standing do
    @moduledoc "A single entry's standing within a classic league."

    alias ExFPL.Decode

    @type t :: %__MODULE__{
            id: integer(),
            event_total: integer() | nil,
            player_name: String.t(),
            rank: integer() | nil,
            last_rank: integer() | nil,
            rank_sort: integer() | nil,
            total: integer(),
            entry: integer(),
            entry_name: String.t()
          }

    defstruct [
      :id,
      :event_total,
      :player_name,
      :rank,
      :last_rank,
      :rank_sort,
      :total,
      :entry,
      :entry_name
    ]

    @fields [
      :id,
      :event_total,
      :player_name,
      :rank,
      :last_rank,
      :rank_sort,
      :total,
      :entry,
      :entry_name
    ]

    @doc false
    @spec from_api(map()) :: t()
    def from_api(data), do: Decode.cast(__MODULE__, @fields, data)
  end

  @type t :: %__MODULE__{
          league: map(),
          new_entries: [map()],
          page: integer(),
          has_next: boolean(),
          standings: [Standing.t()]
        }

  defstruct league: %{}, new_entries: [], page: 1, has_next: false, standings: []

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data) when is_map(data) do
    standings = Map.get(data, "standings", %{})

    %__MODULE__{
      league: Map.get(data, "league", %{}),
      new_entries: data |> Map.get("new_entries", %{}) |> Map.get("results", []),
      page: Map.get(standings, "page", 1),
      has_next: Map.get(standings, "has_next", false),
      standings: Decode.cast_list(Standing, fields(), Map.get(standings, "results", []))
    }
  end

  defp fields do
    [
      :id,
      :event_total,
      :player_name,
      :rank,
      :last_rank,
      :rank_sort,
      :total,
      :entry,
      :entry_name
    ]
  end
end
