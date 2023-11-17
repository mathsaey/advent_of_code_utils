defmodule AOC.Helpers do
  @moduledoc false
  @aoc_time_zone "EST"

  def app_env_val(key, default), do: Application.get_env(:advent_of_code_utils, key, default)

  defp time_zone do
    case app_env_val(:time_zone, :local) do
      :local -> :local
      :aoc -> @aoc_time_zone
      zone when is_binary(zone) -> zone
    end
  end

  defp now do
    case time_zone() do
      :local -> NaiveDateTime.local_now()
      zone -> DateTime.now!(zone, Tz.TimeZoneDatabase)
    end
  end

  def day, do: app_env_val(:day, now().day)
  def year, do: app_env_val(:year, now().year)

  def module_name(year, day) do
    mod_year = "Y#{year}" |> String.to_atom()
    mod_day = "D#{day}" |> String.to_atom()
    Module.concat(mod_year, mod_day)
  end

  def test_module_name(year, day) do
    module_name(year, day)
    |> Module.concat(AOCTest)
  end

  defp expand_template(template, year, day) do
    template
    |> String.replace(":year", Integer.to_string(year))
    |> String.replace(":day", Integer.to_string(day))
  end

  def input_path(year, day) do
    app_env_val(:input_path, "input/:year_:day.txt")
    |> expand_template(year, day)
  end

  def example_path(year, day) do
    app_env_val(:example_path, "input/:year_:day_example.txt")
    |> expand_template(year, day)
  end

  def code_path(year, day) do
    app_env_val(:code_path, "lib/:year/:day.ex")
    |> expand_template(year, day)
  end

  defp path_to_string(path), do: path |> File.read!() |> String.trim_trailing("\n")

  @spec input_string(pos_integer(), pos_integer()) :: String.t()
  def input_string(year, day), do: input_path(year, day) |> path_to_string()

  @spec example_string(pos_integer(), pos_integer()) :: String.t()
  def example_string(year, day), do: example_path(year, day) |> path_to_string()

  def parse_args!(args) do
    switches = [session: :string, year: :integer, day: :integer, example: :boolean]
    aliases = [s: :session, y: :year, d: :day]

    opts =
      case OptionParser.parse(args, aliases: aliases, strict: switches) do
        {opts, [], []} -> opts
        {_, [], any} -> Mix.raise("Invalid option(s): #{inspect(any)}")
        {_, any, _} -> Mix.raise("Unexpected argument(s): #{inspect(any)}")
      end

    session = app_env_val(:session, nil)

    example =
      Keyword.get(
        opts,
        :example,
        app_env_val(:fetch_example?, true)
      )

    {opts[:session] || session, opts[:year] || year(), opts[:day] || day(), example}
  end
end
