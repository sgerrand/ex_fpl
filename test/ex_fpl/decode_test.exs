defmodule ExFPL.DecodeTest do
  use ExUnit.Case, async: true

  defmodule Sample do
    defstruct [:id, :name, :team_id]
  end

  test "cast/3 maps simple atom fields by stringified key" do
    assert ExFPL.Decode.cast(Sample, [:id, :name], %{"id" => 1, "name" => "x"}) ==
             %Sample{id: 1, name: "x"}
  end

  test "cast/3 supports {field, source_key} renaming" do
    data = %{"team" => 5}
    assert ExFPL.Decode.cast(Sample, [{:team_id, "team"}], data) == %Sample{team_id: 5}
  end

  test "cast/3 fills missing keys with nil" do
    assert ExFPL.Decode.cast(Sample, [:id, :name], %{"id" => 1}) ==
             %Sample{id: 1, name: nil}
  end

  test "cast_list/3 returns [] for nil" do
    assert ExFPL.Decode.cast_list(Sample, [:id], nil) == []
  end

  test "cast_list/3 maps a list of maps" do
    items = [%{"id" => 1}, %{"id" => 2}]
    assert ExFPL.Decode.cast_list(Sample, [:id], items) == [%Sample{id: 1}, %Sample{id: 2}]
  end
end
