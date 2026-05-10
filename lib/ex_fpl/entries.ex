defmodule ExFPL.Entries do
  @moduledoc """
  Fetch ExFPL manager (entry) data.

  `get/2`, `history/2` and `picks/3` are public endpoints. `me/1` and
  `my_team/2` are authenticated and require an `ExFPL.Session`.
  """

  alias ExFPL.{Entry, EntryHistory, HTTP, Me, MyTeam, Picks}

  @doc "Fetch a manager's profile (`/entry/{team_id}/`)."
  @spec get(integer(), keyword()) :: {:ok, Entry.t() | map()} | {:error, term()}
  def get(team_id, opts \\ []) when is_integer(team_id) do
    {raw, opts} = Keyword.pop(opts, :raw, false)

    with {:ok, body} <- HTTP.get("/entry/#{team_id}/", opts) do
      decode(body, raw, &Entry.from_api/1)
    end
  end

  @doc "Fetch a manager's history (`/entry/{team_id}/history/`)."
  @spec history(integer(), keyword()) :: {:ok, EntryHistory.t() | map()} | {:error, term()}
  def history(team_id, opts \\ []) when is_integer(team_id) do
    {raw, opts} = Keyword.pop(opts, :raw, false)

    with {:ok, body} <- HTTP.get("/entry/#{team_id}/history/", opts) do
      decode(body, raw, &EntryHistory.from_api/1)
    end
  end

  @doc "Fetch a manager's picks for a gameweek (`/entry/{team_id}/event/{gw}/picks/`)."
  @spec picks(integer(), integer(), keyword()) :: {:ok, Picks.t() | map()} | {:error, term()}
  def picks(team_id, gameweek, opts \\ []) when is_integer(team_id) and is_integer(gameweek) do
    {raw, opts} = Keyword.pop(opts, :raw, false)

    with {:ok, body} <- HTTP.get("/entry/#{team_id}/event/#{gameweek}/picks/", opts) do
      decode(body, raw, &Picks.from_api/1)
    end
  end

  @doc """
  Fetch information about the authenticated user (`/me/`).

  Requires `session: %ExFPL.Session{}` in `opts`.
  """
  @spec me(keyword()) :: {:ok, Me.t() | map()} | {:error, term()}
  def me(opts) do
    require_session!(opts)
    {raw, opts} = Keyword.pop(opts, :raw, false)

    with {:ok, body} <- HTTP.get("/me/", opts) do
      decode(body, raw, &Me.from_api/1)
    end
  end

  @doc """
  Fetch the authenticated user's current team (`/my-team/{team_id}/`).

  Requires `session: %ExFPL.Session{}` in `opts`.
  """
  @spec my_team(integer(), keyword()) :: {:ok, MyTeam.t() | map()} | {:error, term()}
  def my_team(team_id, opts) when is_integer(team_id) do
    require_session!(opts)
    {raw, opts} = Keyword.pop(opts, :raw, false)

    with {:ok, body} <- HTTP.get("/my-team/#{team_id}/", opts) do
      decode(body, raw, &MyTeam.from_api/1)
    end
  end

  defp decode(body, true, _decoder), do: {:ok, body}
  defp decode(body, false, decoder), do: {:ok, decoder.(body)}

  defp require_session!(opts) do
    case Keyword.get(opts, :session) do
      %ExFPL.Session{} ->
        :ok

      _ ->
        raise ArgumentError, "this endpoint requires a session: pass `session: %ExFPL.Session{}`"
    end
  end
end
