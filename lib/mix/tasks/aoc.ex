defmodule Mix.Tasks.Aoc do
  @moduledoc """
  Create a code skeleton and fetch input for the AOC challenge of a day / year.

  This mix task runs `mix aoc.gen` followed by `mix aoc.get`. Afterwards, it prints the url of
  today's challenge. Please refer to `mix help aoc.gen` and `mix help aoc.get` for more
  information.

  ## `mix aoc.gen`

  This task creates a code skeleton for the AOC challenge of a given day / year. The generated
  code is written to `lib/<year>/<day>.ex`. Optionally, a unit test file is generated in
  `test/<year>/<day>_test.exs`. The location where files are created can be customized.

  ## `mix aoc.get`

  This task fetches the input and example inputs for a given day and year and stores it in
  `input/<year>_<day>.txt` and `input/<year>_<day>_example_<n>.txt`. In order for this task to
  work, your session cookie should be passed as a command line argument or set up in the
  `:advent_of_code_utils` application environment.

  ## Configuration

  ### Application environment

  The following [application configuration parameters](`Config`) can modify the behaviour of this
  task:

  - `day`: Specify the day. Defaults to the current day.
  - `year`: Specify the year. Defaults to the current year.
  - `time_zone`: Specify the time-zone used to determine the local time. Defaults to the time zone
    of your computer.  Please refer to the [README](readme.html#time-zones) for additional
    information.
  - `session`: Advent of code sessions cookie. Needed to allow `mix aoc.get` to fetch your
    personal puzzle input.
  - `input_path`: Determines where `mix aoc.get` stores the input file. Defaults to
    `"input/:year_:day.txt"`
  - `example_path`: Determines where `mix aoc.get` stores the example inputs. Defaults to
    `"input/:year_:day_example_:n.txt"`
  - `gen_tests?`: Determines if `mix aoc.gen` creates test files. Defaults to `false`.
  - `gen_doctests?`: Determines if `mix aoc.gen` creates doctests. Defaults to the value of
    `gen_tests?`.
  - `code_path`: Determines where `mix aoc.gen` stores the generated code file. Defaults to
    `"lib/:year/:day.ex"`.
  - `code_path`: Determines where `mix aoc.gen` stores the generated test file. Defaults to
    `"test/:year/:day_test.exs"`

  ### Command-line arguments

  - `-y` or `--year`: Specify the year.
  - `-d` or `--day`: Specify the day.
  - `-s` or `--session`: Specify the session cookie.
  - `--example`: Fetch example input (the default)
  - `--no-example`: Do not fetch example input
  - `-t` or `--test`: Generate tests.
  - `--no-test`: Do not generate tests.
  - `--doctest` or `--no-doctest`: Enable or disable the creation of doctests.

  All of these options take precedence over their application environment counterparts.
  """
  @shortdoc "Fetch input and create code skeleton"
  use Mix.Task
  alias AOC.Helpers

  @impl true
  def run(args) do
    opts = Helpers.parse_args!(args, [:day, :year, :session, :example, :test, :doctest])
    do_try(Mix.Tasks.Aoc.Gen, "gen", opts)
    do_try(Mix.Tasks.Aoc.Get, "get", opts)
    Mix.shell().info("Today's challenge can be found at: #{url(opts[:year], opts[:day])}")
  end

  defp do_try(mod, name, opts) do
    try do
      mod.run_task(opts)
    rescue
      e in Mix.Error -> Mix.shell().info([:red, "* ", name, " error ", :reset, e.message])
    end
  end

  @doc false
  def url(year, day), do: ~c"https://adventofcode.com/#{year}/day/#{day}"
end
