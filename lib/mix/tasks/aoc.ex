defmodule Mix.Tasks.Aoc do
  @doc """
  Fetch input and create a code skeleton for a given day / year.

  This mix task:
  - Creates a code skeleton for the specified `day` / `year`
  - Fetches the input of `day` / `year` and stores it
  - Prints the url of today's challenge.

  If this task is run multiple times for the same `day` / `year`, the input is not fetched again
  (if it has not been deleted) and existing files are not overwritten.

  ## Session cookie

  In order to fetch your input, this task needs your advent of code session cookie. This can be
  obtained by investigating your cookies after logging in on the advent of code website. The
  cookie can be stored inside your `config/config.exs` file (e.g.
  `config, :advent_of_code_utils, :session, "<your cookie here>"`) or it can be passed as a
  command-line argument.  If no cookie is present, the input can not be fetched.

  ## Day and Year

  The day and year can be passed as a command-line argument or be specified in the application
  configuration. If neither of these are present, today's date is used.

  ## File locations

  By default, this task stores the fetched inputs in `input/<year>_<day>.txt`. The code skeletons
  are stored in `lib/<year>/<day>.ex`. These values can be modified by setting the `:input_path`
  and `:code_path` values of the `:advent_of_code_utils` application. The provided path should be
  a string which may contain `:year` and `:day`. If these values are present, they will be
  replaced by the relevant `day` or `year`.

  For instance, the following code will store inputs in `inputs/<year>/<day>.input`:

  ```
  config :advent_of_code_utils, :input_path, "inputs/:year/:day.input"
  ```

  ## Command-line arguments

  - `-s` or `--session`: Specify the session cookie.
  - `-y` or `--year`: Specify the year.
  - `-d` or `--day`: Specify the day.

  All of these options take precedence over their application environment counterparts.
  """
  @shortdoc "Fetch input and create code skeletons"
  use Mix.Task

  def run(args) do
    {session, year, day} = parse_args(args)

    code_path = AOC.Helpers.code_path(year, day)
    code_dir = Path.dirname(code_path)

    unless File.exists?(code_path) do
      info("Creating code path: ", code_path)
      File.mkdir_p!(code_dir)
      File.write(code_path, template(year, day))
    end

    input_path = AOC.Helpers.input_path(year, day)
    input_dir = Path.dirname(input_path)

    unless File.exists?(input_path) do
      info("Fetching input...")

      case get_input(session, year, day) do
        {:ok, input} ->
          File.mkdir_p!(input_dir)
          File.write(input_path, input)
          info("Stored input: ", input_path)

        :error ->
          error("Could not fetch input. Please verify:")
          error("- Your cookie is set up correctly")
          error("- There is an input today")
      end
    end

    info("Today's challenge can be found at: ", url(year, day))
  end

  # ----- #
  # Utils #
  # ----- #

  defp info(msg, extra \\ ""), do: Mix.shell().info([:green, msg, :reset, extra])
  defp error(msg), do: Mix.shell().info([:red, msg])

  defp template(year, day) do
    """
    import AOC

    aoc #{year}, #{day} do
      def p1 do
      end

      def p2 do
      end
    end
    """
  end

  # --------- #
  # Arguments #
  # --------- #

  defp parse_args(args) do
    {kw, _, _} =
      OptionParser.parse(
        args,
        aliases: [s: :session, y: :year, d: :day],
        strict: [session: :string, year: :integer, day: :integer]
      )

    session = Application.get_env(:advent_of_code_utils, :session, nil)
    year = AOC.Helpers.year()
    day = AOC.Helpers.day()

    {kw[:session] || session, kw[:year] || year, kw[:day] || day}
  end

  # ----- #
  # Input #
  # ----- #

  defp get_input(session, year, day) do
    start_applications()
    resp = :httpc.request(:get, {"#{url(year, day)}/input", [cookie(session)]}, [], [])

    case resp do
      {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, body}} -> {:ok, body}
      _ -> :error
    end
  end

  defp start_applications do
    :ok = Application.ensure_started(:inets)
    :ok = Application.ensure_started(:crypto)
    :ok = Application.ensure_started(:asn1)
    :ok = Application.ensure_started(:public_key)
    :ok = Application.ensure_started(:ssl)
  end

  defp url(year, day), do: to_charlist("https://adventofcode.com/#{year}/day/#{day}")
  defp cookie(session), do: {'Cookie', to_charlist("session=#{session}")}
end
