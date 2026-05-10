defmodule ExFPL.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/sgerrand/ex_fpl"

  def project do
    [
      app: :ex_fpl,
      version: @version,
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],

      # Hex
      description: "Elixir client for the Fantasy Premier League REST API.",
      name: "ExFPL",
      package: package(),

      # Docs
      docs: docs(),
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExFPL.Application, []}
    ]
  end

  def cli do
    [
      preferred_envs: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:req, "~> 0.5"},
      {:jason, "~> 1.4"},
      {:telemetry, "~> 1.2"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:plug, "~> 1.16", only: :test}
    ]
  end

  defp package do
    [
      licenses: ["BSD-2-Clause"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      main: "ExFPL",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
