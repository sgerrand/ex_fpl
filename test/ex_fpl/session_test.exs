defmodule ExFPL.SessionTest do
  use ExUnit.Case, async: true

  doctest ExFPL.Session

  test "new/1 builds a session struct" do
    assert %ExFPL.Session{cookie: "abc"} = ExFPL.Session.new(cookie: "abc")
  end

  test "new/1 raises when cookie is missing" do
    assert_raise KeyError, fn -> ExFPL.Session.new([]) end
  end
end
