defmodule Mix.Tasks.Aoc do
  @moduledoc """
  Create a code skeleton and fetch input for the AOC challenge of a day / year.

  This mix task runs `mix aoc.gen` followed by `mix aoc.get`. Afterwards, it prints the url of
  today's challenge.

  ## `mix aoc.gen`

  This task generates a code skeleton for the given day and year in `lib/<year>/<day>.ex`, which
  uses the `AOC.aoc/3` macro. To customise the path where code is stored, refer to the
  `mix aoc.gen` documentation.

  ## `mix aoc.get`

  This task fetches the input for a given day and year and stores it in `input/<year>_<day>.txt`.
  In order for this task to work, your session cookie should be passed as a command line argument
  or set up in the `:advent_of_code_utils` application environment. Please refer to the
  `mix aoc.get` documenntation for more information.

  ## Command-line arguments

  - `-s` or `--session`: Specify the session cookie.
  - `-y` or `--year`: Specify the year.
  - `-d` or `--day`: Specify the day.

  All of these options take precedence over their application environment counterparts.
  """
  @shortdoc "Fetch input and create code skeletons"
  use Mix.Task
  alias AOC.Helpers

  def run(args) do
    {_, year, day} = Helpers.parse_args!(args)
    do_try(Mix.Tasks.Aoc.Gen, "gen", args)
    do_try(Mix.Tasks.Aoc.Get, "get", args)
    Mix.shell().info("Today's challenge can be found at: #{url(year, day)}")
  end

  def do_try(mod, name, args) do
    try do
      mod.run(args)
    rescue
      e in Mix.Error -> Mix.shell().info([:red, "* ", name, " error ", :reset, e.message])
    end
  end

  def url(year, day), do: to_charlist("http://adventofcode.com/#{year}/day/#{day}")
end
