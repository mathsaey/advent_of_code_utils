defmodule AOC.Helpers do
  @moduledoc false

  def time_zone, do: Application.get_env(:advent_of_code_utils, :time_zone, "EST")

  def now do
    case DateTime.now(time_zone(), Tz.TimeZoneDatabase) do
      {:ok, datetime} -> datetime
      _ -> NaiveDateTime.local_now()
    end
  end

  def day, do: Application.get_env(:advent_of_code_utils, :day, now().day)
  def year, do: Application.get_env(:advent_of_code_utils, :year, now().year)

  def module_name(year, day) do
    mod_year = "Y#{year}" |> String.to_atom()
    mod_day = "D#{day}" |> String.to_atom()
    Module.concat(mod_year, mod_day)
  end

  defp expand_template(template, year, day) do
    template
    |> String.replace(":year", Integer.to_string(year))
    |> String.replace(":day", Integer.to_string(day))
  end

  def input_path(year, day) do
    :advent_of_code_utils
    |> Application.get_env(:input_path, "input/:year_:day.txt")
    |> expand_template(year, day)
  end

  def example_path(year, day) do
    :advent_of_code_utils
    |> Application.get_env(:example_path, "input/:year_:day_example.txt")
    |> expand_template(year, day)
  end

  def code_path(year, day) do
    :advent_of_code_utils
    |> Application.get_env(:code_path, "lib/:year/:day.ex")
    |> expand_template(year, day)
  end

  def parse_args!(args) do
    switches = [session: :string, year: :integer, day: :integer, example: :boolean]
    aliases = [s: :session, y: :year, d: :day]

    opts =
      case OptionParser.parse(args, aliases: aliases, strict: switches) do
        {opts, [], []} -> opts
        {_, [], any} -> Mix.raise("Invalid option(s): #{inspect(any)}")
        {_, any, _} -> Mix.raise("Unexpected argument(s): #{inspect(any)}")
      end

    session = Application.get_env(:advent_of_code_utils, :session, nil)

    example =
      Keyword.get(
        opts,
        :example,
        Application.get_env(:advent_of_code_utils, :fetch_example, true)
      )

    {opts[:session] || session, opts[:year] || year(), opts[:day] || day(), example}
  end
end
