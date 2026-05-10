defmodule ExFPL.Session do
  @moduledoc """
  Authenticated session for ExFPL API calls.

  The Fantasy Premier League site authenticates requests via cookies set after
  a browser login. This library does not implement the login flow itself —
  callers obtain the cookie value (typically `pl_profile`) from a logged-in
  browser and construct a session struct manually:

      session = ExFPL.Session.new(cookie: "pl_profile=...; sessionid=...")
      ExFPL.Entries.me(session: session)

  Functions that target authenticated endpoints (`ExFPL.Entries.me/1`,
  `ExFPL.Entries.my_team/2`) require a session.
  """

  @type t :: %__MODULE__{cookie: String.t()}

  @enforce_keys [:cookie]
  defstruct [:cookie]

  @doc """
  Build a session from a cookie string copied from a logged-in browser.

  ## Examples

      iex> ExFPL.Session.new(cookie: "pl_profile=abc")
      %ExFPL.Session{cookie: "pl_profile=abc"}
  """
  @spec new(keyword()) :: t()
  def new(opts) do
    cookie = Keyword.fetch!(opts, :cookie)
    %__MODULE__{cookie: cookie}
  end
end
