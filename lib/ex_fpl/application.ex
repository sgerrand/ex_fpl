defmodule ExFPL.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [ExFPL.Cache]
    opts = [strategy: :one_for_one, name: ExFPL.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
