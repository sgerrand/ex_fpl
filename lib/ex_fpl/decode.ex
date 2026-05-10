defmodule ExFPL.Decode do
  @moduledoc false

  @doc """
  Cast a map with string keys into a struct of `module` using `fields`.

  Each entry in `fields` is either an atom (the same name is used in both the
  struct and the source map) or `{struct_field, "source_key"}` to rename.
  """
  @spec cast(module(), [atom() | {atom(), String.t()}], map()) :: struct()
  def cast(module, fields, data) when is_map(data) do
    attrs =
      Enum.reduce(fields, %{}, fn
        {field, source_key}, acc ->
          Map.put(acc, field, Map.get(data, source_key))

        field, acc when is_atom(field) ->
          Map.put(acc, field, Map.get(data, Atom.to_string(field)))
      end)

    struct(module, attrs)
  end

  @doc "Cast a list of maps using `cast/3`."
  @spec cast_list(module(), [atom() | {atom(), String.t()}], [map()] | nil) :: [struct()]
  def cast_list(_module, _fields, nil), do: []

  def cast_list(module, fields, list) when is_list(list) do
    Enum.map(list, &cast(module, fields, &1))
  end
end
