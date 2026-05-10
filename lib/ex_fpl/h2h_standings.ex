defmodule ExFPL.H2HStandings do
  @moduledoc "Decoded `/leagues-h2h/{league_id}/standings/` response."

  alias ExFPL.Decode

  defmodule Standing do
    @moduledoc "A single entry's standing within a head-to-head league."

    alias ExFPL.Decode

    @type t :: %__MODULE__{
            id: integer(),
            division: integer() | nil,
            entry: integer(),
            player_name: String.t(),
            rank: integer() | nil,
            last_rank: integer() | nil,
            rank_sort: integer() | nil,
            total: integer(),
            entry_name: String.t(),
            matches_played: integer(),
            matches_won: integer(),
            matches_drawn: integer(),
            matches_lost: integer(),
            points_for: integer()
          }

    defstruct [
      :id,
      :division,
      :entry,
      :player_name,
      :rank,
      :last_rank,
      :rank_sort,
      :total,
      :entry_name,
      :matches_played,
      :matches_won,
      :matches_drawn,
      :matches_lost,
      :points_for
    ]

    @fields [
      :id,
      :division,
      :entry,
      :player_name,
      :rank,
      :last_rank,
      :rank_sort,
      :total,
      :entry_name,
      :matches_played,
      :matches_won,
      :matches_drawn,
      :matches_lost,
      :points_for
    ]

    @doc false
    @spec from_api(map()) :: t()
    def from_api(data), do: Decode.cast(__MODULE__, @fields, data)
  end

  @type t :: %__MODULE__{
          league: map(),
          page: integer(),
          has_next: boolean(),
          standings: [Standing.t()]
        }

  defstruct league: %{}, page: 1, has_next: false, standings: []

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data) when is_map(data) do
    standings = Map.get(data, "standings", %{})

    %__MODULE__{
      league: Map.get(data, "league", %{}),
      page: Map.get(standings, "page", 1),
      has_next: Map.get(standings, "has_next", false),
      standings: Decode.cast_list(Standing, h2h_fields(), Map.get(standings, "results", []))
    }
  end

  defp h2h_fields do
    [
      :id,
      :division,
      :entry,
      :player_name,
      :rank,
      :last_rank,
      :rank_sort,
      :total,
      :entry_name,
      :matches_played,
      :matches_won,
      :matches_drawn,
      :matches_lost,
      :points_for
    ]
  end
end
