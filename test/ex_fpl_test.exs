defmodule ExFPLTest do
  use ExUnit.Case, async: true
  doctest ExFPL

  test "module exists with documentation" do
    {:docs_v1, _, _, _, %{"en" => moduledoc}, _, _} = Code.fetch_docs(ExFPL)
    assert moduledoc =~ "Fantasy Premier League"
  end
end
