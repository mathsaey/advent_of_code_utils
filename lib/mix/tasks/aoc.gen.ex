defmodule Mix.Tasks.Aoc.Gen do
  @moduledoc """
  Create a code skeleton for the AOC challenge of a given day / year.

  This mix task creates a code skeleton for the advent of code challenge of a specific day. The
  day and year of the challenge can be passed as command-line arguments or be set in the
  `advent_of_code_utils` application configuration. When neither of these are present, the current
  date is used.

  ## (doc)tests

  By default, this task only generates a solution module file. When `gen_tests?` is set to `true`
  in the application configuration (i.e. in `config/config.exs`), or when `--test` is passed as an
  option to this task, this task will also generate a unit test file. Moreover, it will also add
  doctests to the solution module.

  If you do not wish to generate doctests, you can set `gen_doctests?` to `false` in the
  application configuration or pass the `--no-doctest` option to this task.

  ### Generating tests later on

  This task will never overwrite existing files. Therefore, if you run `mix aoc.gen --test` after
  a previous run of `mix aoc.gen` (without `--test`), this task will create a unit test file and
  leave the existing file alone. This is useful if you wish to add tests to existing code.

  Note that adding the `--doctest` flag when a solution module has already been generated will not
  work, as this task will never overwrite existing files.

  ## File locations

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

  If tests are generated, they are stored in `test/<year>/<day>_test.exs`. This value can be
  modified by setting `test_path` in the application configuration. Note that, in order for the
  test to work with `mix test`, the test path must end in `_test.exs`.

  ## Configuration

  ### Application environment

  The following [application configuration parameters](`Config`) can modify the behaviour of this
  task:

  - `day`: Specify the day. Defaults to the current day.
  - `year`: Specify the year. Defaults to the current year.
  - `time_zone`: Specify the time-zone used to determine the local time. Defaults to the time zone
    of your computer.  Please refer to the [README](readme.html#time-zones) for additional
    information.
  - `gen_tests?`: Determines if test files are created. Defaults to `false`.
  - `gen_doctests?`: Determines if doctests are generated. Defaults to the value of `gen_tests?`.
  - `code_path`: Determines where the generated code file is stored. Defaults to
    `"lib/:year/:day.ex"`.
  - `code_path`: Determines where the generated test file is stored. Defaults to
    `"test/:year/:day_test.exs"`

  ### Command-line arguments

  The options below take precedence over values defined in the application configuration.

  - `-d` or `--day`: Specify the day.
  - `-y` or `--year`: Specify the year.
  - `-t` or `--test`: Generate tests.
  - `--no-test`: Do not generate tests.
  - `--doctest` or `--no-doctest`: Enable or disable the creation of doctests.
  """
  @shortdoc "Generate AOC code skeleton"
  use Mix.Task
  import Mix.Generator

  alias AOC.Helpers

  @impl true
  def run(args), do: args |> Helpers.parse_args!([:day, :year, :test, :doctest]) |> run_task()

  def run_task(opts) do
    day = opts[:day]
    year = opts[:year]
    tests = opts[:test] || Helpers.app_env_val(:gen_tests?, false)
    doctests = Keyword.get(opts, :doctest, Helpers.app_env_val(:gen_doctests?, tests))

    validate_test_setup!(year, day, tests, doctests)

    solution_path = Helpers.code_path(year, day)
    solution_content = solution_template(year: year, day: day, doctests: doctests)
    maybe_create_file(solution_path, solution_content)

    if tests do
      test_path = Helpers.test_path(year, day)
      test_content = test_template(year: year, day: day)
      maybe_create_file(test_path, test_content)
    end
  end

  defp validate_test_setup!(year, day, tests, doctests) do
    test_path = Helpers.test_path(year, day)

    unless String.ends_with?(test_path, "_test.exs") do
      Mix.raise("Test path must end in _test.exs in order to work with `mix test`")
    end

    if doctests and not tests do
      Mix.shell().info([
        :red,
        "! ",
        :reset,
        "Doctest generation is enabled, but test generation is not.",
        "\n",
        :red,
        "! ",
        :reset,
        "Doctests will not be executed unless you write your own unit test files."
      ])
    end
  end

  defp maybe_create_file(path, contents) do
    dir = Path.dirname(path)

    if File.exists?(path) do
      Mix.shell().info([:yellow, "* skipping ", :reset, path, " (already exists)"])
    else
      Mix.shell().info([:green, "* creating ", :reset, path])
      File.mkdir_p!(dir)
      File.write(path, contents)
    end
  end

  embed_template(:solution, """
  import AOC

  aoc <%= @year %>, <%= @day %> do
    <%= if @doctests do %>@moduledoc \"\"\"
    <%= Mix.Tasks.Aoc.url(@year, @day) %>
    \"\"\"

    @doc \"\"\"
        iex> p1(example_string())
    \"\"\"
    <% end %>def p1(input) do
      input
    end

    <%= if @doctests do %>@doc \"\"\"
        iex> p2(example_string())
    \"\"\"
    <% end %>def p2(input) do
      input
    end
  end
  """)

  embed_template(:test, """
  import AOC

  aoc_test <%= @year %>, <%= @day %>, async: true do
  end
  """)
end
