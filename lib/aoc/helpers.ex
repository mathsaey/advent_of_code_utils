defmodule AOC.Helpers do
  @moduledoc false

  def day, do: Application.get_env(:advent_of_code_utils, :day, Date.utc_today().day)
  def year, do: Application.get_env(:advent_of_code_utils, :year, Date.utc_today().year)

  def module_name(year, day) do
    mod_year = "Y#{year}" |> String.to_atom()
    mod_day = "D#{day}" |> String.to_atom()
    Module.concat(mod_year, mod_day)
  end

  def input_path(year, day) do
    template = Application.get_env(:advent_of_code_utils, :input_path, "input/:year_:day.txt")

    template
    |> String.replace(":year", Integer.to_string(year))
    |> String.replace(":day", Integer.to_string(day))
  end

  def code_path(year, day) do
    template = Application.get_env(:advent_of_code_utils, :code_path, "lib/:year/:day.ex")

    template
    |> String.replace(":year", Integer.to_string(year))
    |> String.replace(":day", Integer.to_string(day))
  end
end
