defmodule ExFPL.Fixtures do
  @moduledoc "Fetch fixtures from `/fixtures/`, optionally filtered by gameweek."

  alias ExFPL.{Fixture, HTTP}

  @type list_opts :: [event: integer(), raw: boolean()] | keyword()

  @doc """
  List fixtures.

  Pass `event: gameweek_id` to restrict the response to one gameweek. Pass
  `raw: true` to receive the original list of maps with string keys instead
  of `ExFPL.Fixture` structs.
  """
  @spec list(list_opts()) :: {:ok, [Fixture.t()] | [map()]} | {:error, term()}
  def list(opts \\ []) do
    {event, opts} = Keyword.pop(opts, :event)
    {raw, opts} = Keyword.pop(opts, :raw, false)

    request_opts =
      case event do
        nil -> opts
        id -> Keyword.put(opts, :params, event: id)
      end

    with {:ok, body} <- HTTP.get("/fixtures/", request_opts) do
      if raw do
        {:ok, body}
      else
        {:ok, Enum.map(body, &Fixture.from_api/1)}
      end
    end
  end
end
