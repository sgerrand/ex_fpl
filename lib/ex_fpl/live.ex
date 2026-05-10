defmodule ExFPL.Live do
  @moduledoc "Fetch live gameweek data from `/event/{event_id}/live/`."

  alias ExFPL.{HTTP, LiveSnapshot}

  @doc """
  Fetch the live snapshot for the given gameweek.

  Pass `raw: true` to receive the raw JSON-decoded map.
  """
  @spec fetch(integer(), keyword()) :: {:ok, LiveSnapshot.t() | map()} | {:error, term()}
  def fetch(event_id, opts \\ []) when is_integer(event_id) do
    {raw, opts} = Keyword.pop(opts, :raw, false)

    with {:ok, body} <- HTTP.get("/event/#{event_id}/live/", opts) do
      if raw do
        {:ok, body}
      else
        {:ok, LiveSnapshot.from_api(body)}
      end
    end
  end
end
