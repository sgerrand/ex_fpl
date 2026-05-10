defmodule ExFPL.HTTP do
  @moduledoc """
  Thin wrapper around `Req` that handles base URL, retries, telemetry and
  optional session cookies for ExFPL API requests.

  Library code should not call `Req` directly — go through `get/2` so the
  test stub and telemetry events apply uniformly.
  """

  @base_url "https://fantasy.premierleague.com/api"

  @typedoc "Decoded JSON body returned by the API."
  @type body :: map() | list()

  @typedoc "Errors returned by `get/2`."
  @type error ::
          {:http_error, status :: pos_integer(), body :: term()}
          | Exception.t()
          | term()

  @doc """
  Issue a GET request to the ExFPL API.

  Options:

    * `:session` — a `ExFPL.Session{}` whose `cookie` will be sent as the
      `cookie` request header.
    * `:params` — query string parameters (a keyword list).
    * any other key is forwarded to `Req.request/1`.

  Returns `{:ok, body}` on a 2xx response and `{:error, reason}` otherwise.
  """
  @spec get(String.t(), keyword()) :: {:ok, body()} | {:error, error()}
  def get(path, opts \\ []) do
    {session, opts} = Keyword.pop(opts, :session)
    {params, opts} = Keyword.pop(opts, :params)

    base_opts = [
      method: :get,
      url: @base_url <> path,
      retry: :safe_transient,
      retry_log_level: :warning
    ]

    base_opts =
      base_opts
      |> maybe_put(:params, params)
      |> with_session(session)
      |> Keyword.merge(Application.get_env(:ex_fpl, :req_options, []))
      |> Keyword.merge(opts)

    started = System.monotonic_time()

    result =
      base_opts
      |> Req.request()
      |> handle_result()

    measurements = %{duration: System.monotonic_time() - started}
    metadata = %{path: path, result: elem(result, 0)}
    :telemetry.execute([:ExFPL, :http, :request], measurements, metadata)

    result
  end

  defp handle_result({:ok, %Req.Response{status: status, body: body}}) when status in 200..299 do
    {:ok, body}
  end

  defp handle_result({:ok, %Req.Response{status: status, body: body}}) do
    {:error, {:http_error, status, body}}
  end

  defp handle_result({:error, reason}) do
    {:error, reason}
  end

  defp maybe_put(opts, _key, nil), do: opts
  defp maybe_put(opts, key, value), do: Keyword.put(opts, key, value)

  defp with_session(opts, %ExFPL.Session{cookie: cookie}) when is_binary(cookie) do
    Keyword.put(opts, :headers, [{"cookie", cookie}])
  end

  defp with_session(opts, nil), do: opts
end
