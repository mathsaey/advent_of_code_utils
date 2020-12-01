defmodule AOC do
  @moduledoc """
  Utilities for advent of code solution modules.

  This module contains a set of macros and helper functions which should be used to generate
  solution modules for advent of code. When solving the problem for `<day>` of `<year>`, this
  module can be imported, after which the `aoc/3` macro can be used to automatically generate a
  solution module. The intended use looks like this:

  ```
  import AOC

  aoc 2020, 1 do

    def p1 do
      input_stream()
      |>  ...
    end

    def p2 do
      input_stream()
      |>  ...
    end
  end
  ```

  Defining a module with the `aoc/3` macro has a few advantages:

  - The `input_path`, `input_string` and `input_stream` functions are generated and inserted into
  the generated module.
  - The `p1/0`, `p1/1`, `p1/2`, `p2/0`, `p2/1` and `p2/2` functions can be used to call the `p1`
  and `p2` functions in this module, making the development experience a bit nicer.

  Overall, the macros in these modules are intended to allow you to forego writing boilerplate
  code which is shared between all the solutions.

  ## `aoc/3` and `use AOC`

  Internally, `aoc/3` generates a module with a predefined name (Y<year>.D<day>) which contains a
  `use AOC, day: <day>, year: <year>` statement. In turn, the `__using__/1` macro defined in this
  module is responsible for generating the `input_*` helper functions. Thus, if you prefer to
  use a different naming scheme than the one imposed by `aoc/3`, you can do something like the
  following:

  ```
  defmodule MySolution do
    use AOC, day: <day>, year: <year>

    ...
  end
  ```

  When using `AOC` like this, you cannot use the `p*` helper functions, but you get access to the
  various `input_*` functions.

  ## `input_*` functions

  Inside the generated module, the following functions are available:

  - `input_path/0`: Get the path to the input for the module's day / year.
  - `input_string/0`: Use `File.read!/1` to read `input_path/0`.
  - `input_stream/0`: Use `File.stream!/1` to read `input_path/0` and map `String.trim/1` over the
  stream.

  Each of these functions is overridable. This makes it possible to add the example input to your
  module when testing your code, for instance, the following code can be used to use the example
  input for year 2020 day 1.

  ```
  aoc 2020, 1 do
    def input_stream do
      [
        "1721",
        "979",
        "366",
        "299",
        "675",
        "1456"
      ]
    end

    ...
  end
  ```

  Besides the `input_*` functions, the following two functions are available:

  - `_aoc_day/0`: Get the day of the module
  - `_aoc_year/0`: Get the year of the module

  ## `p1()`, `p2()` and others

  Inside the body of `aoc/3`, it is intended that you define the solution to part 1 inside a `p1`
  function and the solution to part 2 inside a `p2` function. If you do this, the helpers defined
  in this module can be used to quickly call `p1` or `p2` for a given `day` and `year` from within
  `iex`.

  `day` and `year` can be passed as arguments, if they are not passed as arguments, the
  `:advent_of_code` application environment is checked for the value of `:day` or `:year` (using
  `Application.get_env/3`). If the value is present, it is used, otherwise, the current day or
  year is used. Since the application environment is used, you can override day or year in your
  `config/config.exs` file.
  """
  import AOC.Helpers

  defmacro __using__(opts) do
    day = Keyword.fetch!(opts, :day)
    year = Keyword.fetch!(opts, :year)

    quote do
      def _aoc_day, do: unquote(day)
      def _aoc_year, do: unquote(year)

      def input_path, do: Path.expand(AOC.Helpers.input_path(_aoc_day(), _aoc_year()))
      def input_string, do: File.read!(input_path())
      def input_stream, do: input_path() |> File.stream!() |> Stream.map(&String.trim/1)

      defoverridable input_path: 0
      defoverridable input_stream: 0
      defoverridable input_string: 0
    end
  end

  @doc """

  The generated module will be named `Y<year>.D<day>`. `use AOC` will be injected in the body of
  the module, so that the input helpers described in `AOC` are available.

  ## Examples

  ```
  import AOC

  aoc 2020, 1 do

    def some_function do
      :foo
    end

  end
  ```

  is equivalent to:

  ```
  defmodule Y2020.D1 do
    use AOC

    def some_function do
      :foo
    end
  end
  ```
  """
  defmacro aoc(year, day, do: body) do
    quote do
      defmodule unquote(module_name(year, day)) do
        use unquote(__MODULE__), year: unquote(year), day: unquote(day)

        unquote(body)
      end
    end
  end

  @doc """
  Call `Y<year>.D<day>.p1()`

  `day` and `year` are fetched from the `:advent_of_code_utils` application environment. The
  current day / year is used if these are not set.
  """
  def p1(), do: p1(day(), year())

  @doc """
  Call `Y<year>.D<day>.p2()`

  `day` and `year` are fetched from the `:advent_of_code_utils` application environment. The
  current day / year is used if these are not set.
  """
  def p2(), do: p2(day(), year())

  @doc """
  Call `Y<year>.D<day>.p1()`

  `day` is passed as a parameter, `year` is fetched from the `:advent_of_code_utils` application
  environment. If it is not set, the current year is used.
  """
  def p1(day), do: p1(day, year())

  @doc """
  Call `Y<year>.D<day>.p2()`

  `day` is passed as a parameter, `year` is fetched from the `:advent_of_code_utils` application
  environment. If it is not set, the current year is used.
  """
  def p2(day), do: p2(day, year())

  @doc "Call `Y<year>.D<day>.p1()`"
  def p1(day, year), do: module_name(year, day).p1()

  @doc "Call `Y<year>.D<day>.p2()`"
  def p2(day, year), do: module_name(year, day).p2()
end
