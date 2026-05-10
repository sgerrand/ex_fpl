defmodule ExFPL.Players do
  @moduledoc "Fetch per-player history and upcoming fixtures."

  alias ExFPL.{HTTP, PlayerSummary}

  @doc """
  Fetch a player's summary (`/element-summary/{player_id}/`).

  Pass `raw: true` to receive the raw JSON-decoded map.
  """
  @spec summary(integer(), keyword()) :: {:ok, PlayerSummary.t() | map()} | {:error, term()}
  def summary(player_id, opts \\ []) when is_integer(player_id) do
    {raw, opts} = Keyword.pop(opts, :raw, false)

    with {:ok, body} <- HTTP.get("/element-summary/#{player_id}/", opts) do
      if raw do
        {:ok, body}
      else
        {:ok, PlayerSummary.from_api(body)}
      end
    end
  end
end
