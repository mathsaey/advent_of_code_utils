defmodule Mix.Tasks.Aoc.Gen do
  @moduledoc """
  Create a code skeleton for the AOC challenge of a given day / year.

  This mix task creates a code skeleton for the advent of code challenge of a specific day. The
  day and year of the challenge can be passed as command-line arguments or be set in the
  `advent_of_code_utils` application configuration. When neither of these are present, the current
  date is used.

  By default, this task stores the generated code skeleton in `lib/<year>/<day>.ex`. If this file
  already exists, an error is returned and no files are created. The destination path can be
  modified by setting the value of `:code_path` in the `advent_of_code_utils` application
  configuration. This value should be set to a string which may contain `:year` and `:day`. These
  values will be replaced by the day and year for which a skeleton is generated.

  For instance, the following configuration will store the generated code in
  `lib/aoc_<year>_day_<day>.ex`:

  ```
  config :advent_of_code_utils, :code_path, "lib/aoc_:year_day_:day.ex"
  ```

  ## Command-line arguments

  The options below take precedence over values defined in the application configuration.

  - `-y` or `--year`: Specify the year.
  - `-d` or `--day`: Specify the day.
  """
  @shortdoc "Generate AOC code skeletons"

  use Mix.Task
  import Mix.Generator

  alias AOC.Helpers

  def run(args) do
    {_, year, day, _} = Helpers.parse_args!(args)
    path = Helpers.code_path(year, day)
    dir = Path.dirname(path)

    if File.exists?(path) do
      Mix.shell().info([:yellow, "* Skipping ", :reset, path, " (already exists)"])
    else
      Mix.shell().info([:green, "* Creating ", :reset, path])
      File.mkdir_p!(dir)
      File.write(path, aoc_template([year: year, day: day]))
    end
  end

  embed_template(:aoc, """
    import AOC

    aoc <%= @year %>, <%= @day %> do
      def p1 do
      end

      def p2 do
      end
    end
    """)
end
