defmodule AOC.Case do
  @moduledoc """
  `ExUnit.CaseTemplate` for writing advent of code test cases.

  This template inserts module tags and helper functions into the unit test module. Concretely, it
  inserts a `day`, `year` and `date` module tag, which can be used to selectively test certain
  days using `mix test`. It also inserts `input_path/0`, `example_path/0`, `input_string/0` and
  `example_string/0` helpers which make it possible to access the example and puzzle input from
  within the tests. Trailing newlines are stripped from `input_string/0` and `example_string/0`.

  The `use` statement expects a `year` and `day` option, which are used to generate the correct
  module tags and helper functions.

  Consider using `AOC.aoc_test/4` instead of using this case template.
  """
  use ExUnit.CaseTemplate

  using opts do
    day = Keyword.fetch!(opts, :day)
    year = Keyword.fetch!(opts, :year)
    date = Date.new!(year, 12, day)

    quote do
      @moduletag date: unquote(Macro.escape(date))
      @moduletag year: unquote(year)
      @moduletag day: unquote(day)

      def input_path, do: AOC.Helpers.input_path(unquote(year), unquote(day))
      def example_path, do: AOC.Helpers.example_path(unquote(year), unquote(day))
      def input_string, do: AOC.Helpers.input_string(unquote(year), unquote(day))
      def example_string, do: AOC.Helpers.example_string(unquote(year), unquote(day))
    end
  end
end
