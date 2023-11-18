defmodule AOC.Case do
  @moduledoc """
  `ExUnit.CaseTemplate` for writing advent of code test cases.

  This template inserts module tags and helper functions into the unit test module. Concretely, it
  inserts several module tags, which can be used to selectively test certain days using `mix
  test`. It also inserts several helpers which make it possible to access the example and puzzle
  input within the tests.

  The `use` statement expects a `year` and `day` option, which are used to generate the correct
  module tags and helper functions.

  Consider using `AOC.aoc_test/4` instead of using this case template.

  ## Module tags and filtering

  This case adds the following module tags:

  * `year`: the year of the puzzle
  * `day`: the day of the puzzle
  * `aoc`: the year and day of the puzzle, separated by a dash, e.g. `"1991-8"`

  `mix test` allows you to filter tests based on tags, therefore, you can do the following:

  * `mix test --only year:1991`: will run all tests associated with year 1991.
  * `mix test --only day:8`: will run all tests associated with day 8.

  Specifying multiple `--only` options _combines_ the options, i.e., running
  `mix test --only day:8 --year:1991` will run all tests of year 1991 _and_ all the tests of any
  day 8. This is problematic if your solution repository spans multiple years. Therefore, we
  include the `aoc` tag, which uniquely identifies a day:

  * `mix test --only aoc:1991-8`: will run all the tests associated with day 8 of year 1991.

  If your solution repository only contains modules for a single year, this behaves identical to
  `mix test --only day:8`.

  ## Helpers

  This template injects several helpers into the test module which can be used to access the
  example and puzzle input. These helpers behave similar to those defined in `AOC.IEx`, but always
  fetch the input or example associated with the solution module. The following helpers are
  injected:

  * `example_string/0`: Fetch the example input with trailing newlines removed.
  * `input_string/0`: Fetch the puzzle input, trailing newlines are removed.
  * `input_path/0`: Get the path to the puzzle input.
  * `example_path/0`: Get the path to the example input.
  """
  use ExUnit.CaseTemplate

  using opts do
    day = Keyword.fetch!(opts, :day)
    year = Keyword.fetch!(opts, :year)

    quote do
      @moduletag aoc: "#{unquote(year)}-#{unquote(day)}"
      @moduletag year: unquote(year)
      @moduletag day: unquote(day)

      def input_path, do: AOC.Helpers.input_path(unquote(year), unquote(day))
      def example_path, do: AOC.Helpers.example_path(unquote(year), unquote(day))
      def input_string, do: AOC.Helpers.input_string(unquote(year), unquote(day))
      def example_string, do: AOC.Helpers.example_string(unquote(year), unquote(day))
    end
  end
end
