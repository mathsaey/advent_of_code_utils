defmodule AOC.IEx do
  @moduledoc """
  IEx helpers for advent of code.

  This module contains various helpers that make it easy to call procedures in your solution
  modules. This is particularly useful when you are testing your solutions from within iex.

  In order to avoid prefixing all calls with `AOC.IEx`, we recommend adding `import AOC.IEx` to
  your [`.iex.exs` file](https://hexdocs.pm/iex/IEx.html#module-the-iex-exs-file).

  ## Requirements and `AOC.aoc/3`

  In order to find a module for a given day and year, this module expects the module to have the
  name `Y<year>.D<day>`. This is automatically the case if the `AOC.aoc/3` macro was used to build
  the solution module.

  Besides this, it is expected that the solutions for part 1 and part 2 are defined in non-private
  functions named `p1` and `p2`.

  ## Using this module

  The `p1/0` and `p2/0` functions can be used to call the `p1` and `p2` functions of your solution
  module. By default, these functions are called on the module that represents the current day.
  The current day (and year) is determined by `NaiveDateTime.local_now/0`.

  If it is past midnight, or if you wish to solve an older challenge, there are a few options at
  your disposal:

  - `p1/2` and `p2/2` accept a day and year argument.
  - `p1/1` and `p1/1` accept a day argument and uses the current year by default.
  - The current year and day can be configured through the `:advent_of_code_utils` application
  environment. For instance, you can set the year to `1991` and the day to `8` by placing the
  following in your `config/config.exs`:

  ```
  import Config

  config :advent_of_code_utils,
    day: 8,
    year: 1991
  ```

  To summarise, the day or year is determined according to the following rules:

  1. If year or day was passed as an argument (to `p1/2`, `p1/1`, `p2/2` or `p2/1`) it is always
  used.
  2. If `:year` or `:day` is present in the `:advent_of_code_utils` application environment, it
  is used.
  3. The `year` or `day` returned by `NaiveDateTime.local_now/0` is used.

  ## Automatic recompilation

  It is often necessary to recompile the current `mix` project before running `p1` or `p2`. To
  avoid manually doing this, all the functions in this module will recompile the current mix
  project (with `IEx.Helpers.recompile/1`) before calling `p1` or `p2` when `:auto_compile?` is
  set to `true` in the `:advent_of_code_utils` application environment.

  Auto reload can be enabled by adding the following to your `config/config.exs`:

  ```
  import Config

  config :advent_of_code_utils, auto_compile?: true
  ```
  """
  alias AOC.Helpers

  defp mix_started? do
    Application.started_applications() |> Enum.find(false, fn {name, _, _} -> name == :mix end)
  end

  defp maybe_compile() do
    compile? = Application.get_env(:advent_of_code_utils, :auto_compile?, false)
    if(compile? and mix_started?(), do: IEx.Helpers.recompile())
  end

  @doc """
  Get the module name for `year`, `day`.

  This function may cause recompilation if `auto_compile?` is enabled.

  ## Examples

      iex> mod(1991, 8)
      Y1991.D8
  """
  @spec mod(pos_integer(), pos_integer()) :: module()
  def mod(year, day) do
    maybe_compile()
    Helpers.module_name(year, day)
  end

  @doc """
  Get the module name for `day`, lookup `year`.

  `year` is fetched from the application environment, otherwise the local time is used.
  Please refer to the module documentation for additional information.

  This function may cause recompilation if `auto_compile?` is enabled.

  ## Examples

      iex> Application.put_env(:advent_of_code_utils, :year, 1991)
      iex> mod(8)
      Y1991.D8
      iex> Application.put_env(:advent_of_code_utils, :year, 2000)
      iex> mod(3)
      Y2000.D3
  """
  @spec mod(pos_integer()) :: module()
  def mod(day) do
    maybe_compile()
    Helpers.module_name(Helpers.year(), day)
  end

  @doc """
  Get the module name for the current or configured `day` and `year`.

  `day` and `year` are fetched from the application environment, the local time is used if they
  are not available.
  Please refer to the module documentation for additional information.

  This function may cause recompilation if `auto_compile?` is enabled.

  ## Examples

      iex> Application.put_env(:advent_of_code_utils, :year, 1991)
      iex> Application.put_env(:advent_of_code_utils, :day, 8)
      iex> mod()
      Y1991.D8
      iex> Application.put_env(:advent_of_code_utils, :year, 2000)
      iex> Application.put_env(:advent_of_code_utils, :day, 3)
      iex> mod()
      Y2000.D3
  """
  @spec mod() :: module()
  def mod do
    maybe_compile()
    Helpers.module_name(Helpers.year(), Helpers.day())
  end

  @doc """
  Call `Y<year>.D<day>.p1()`

  `day` and `year` are fetched from the application environment, the local time is used if they
  are not available.
  Please refer to the module documentation for additional information.

  This function may cause recompilation if `auto_compile?` is enabled.
  """
  @spec p1() :: any()
  def p1(), do: p1(Helpers.year(), Helpers.day())

  @doc """
  Call `Y<year>.D<day>.p2()`

  `day` and `year` are fetched from the application environment, the local time is used if they
  are not available.
  Please refer to the module documentation for additional information.

  This function may cause recompilation if `auto_compile?` is enabled.
  """
  @spec p2() :: any()
  def p2(), do: p2(Helpers.year(), Helpers.day())

  @doc """
  Call `Y<year>.D<day>.p1()`

  `year` is fetched from the application environment, the local time is used if it is not
  available.
  Please refer to the module documentation for additional information.

  This function may cause recompilation if `auto_compile?` is enabled.
  """
  @spec p1(pos_integer()) :: any()
  def p1(day), do: p1(Helpers.year(), day)

  @doc """
  Call `Y<year>.D<day>.p2()`

  `year` is fetched from the application environment, the local time is used if it is not
  available.
  Please refer to the module documentation for additional information.

  This function may cause recompilation if `auto_compile?` is enabled.
  """
  @spec p2(pos_integer()) :: any()
  def p2(day), do: p2(Helpers.year(), day)

  @doc """
  Call `Y<year>.D<day>.p1()`

  This function may cause recompilation if `auto_compile?` is enabled.
  """
  @spec p1(pos_integer(), pos_integer()) :: any()
  def p1(year, day), do: mod(year, day).p1()

  @doc """
  Call `Y<year>.D<day>.p2()`

  This function may cause recompilation if `auto_compile?` is enabled.
  """
  @spec p2(pos_integer(), pos_integer()) :: any()
  def p2(year, day), do: mod(year, day).p2()
end
