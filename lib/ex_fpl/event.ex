defmodule ExFPL.Event do
  @moduledoc "A gameweek (\"event\") as returned by `/bootstrap-static/`."

  alias ExFPL.Decode

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          deadline_time: String.t(),
          average_entry_score: integer(),
          finished: boolean(),
          data_checked: boolean(),
          highest_score: integer() | nil,
          is_previous: boolean(),
          is_current: boolean(),
          is_next: boolean(),
          top_element: integer() | nil,
          transfers_made: integer(),
          most_selected: integer() | nil,
          most_transferred_in: integer() | nil,
          most_captained: integer() | nil,
          most_vice_captained: integer() | nil,
          ranked_count: integer()
        }

  defstruct [
    :id,
    :name,
    :deadline_time,
    :average_entry_score,
    :finished,
    :data_checked,
    :highest_score,
    :is_previous,
    :is_current,
    :is_next,
    :top_element,
    :transfers_made,
    :most_selected,
    :most_transferred_in,
    :most_captained,
    :most_vice_captained,
    :ranked_count
  ]

  @fields [
    :id,
    :name,
    :deadline_time,
    :average_entry_score,
    :finished,
    :data_checked,
    :highest_score,
    :is_previous,
    :is_current,
    :is_next,
    :top_element,
    :transfers_made,
    :most_selected,
    :most_transferred_in,
    :most_captained,
    :most_vice_captained,
    :ranked_count
  ]

  @doc false
  @spec from_api(map()) :: t()
  def from_api(data), do: Decode.cast(__MODULE__, @fields, data)
end
