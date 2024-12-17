defmodule Mix.Tasks.Aoc.Get do
  @moduledoc """
  Fetch the input and example input of the AOC challenge for a given day / year.

  This mix task fetches the input and example input for the advent of code challenge of a specific
  day. The day and year of the challenge can be passed as command-line arguments or be set in the
  `advent_of_code_utils` application configuration. When neither is present, the current date is
  used.

  By default, this task stores the fetched input data in `input/<year>_<day>.txt`. The fetched
  example is stored in `input/<year>_<day>_example.txt`. If a file already exists, the matching
  input is not fetched. The destination paths can be modified by setting the value of
  `:input_path` or `:example_path` in the `advent_of_code_utils` application configuration. These
  values should be set to a string which may contain `:year` and `:day`. These values will be
  replaced by the day and year of which the input is fetched.

  For instance, the following configuration will store the fetched input data in
  `my_input/<year>/<day>.input`:

  ```
  config :advent_of_code_utils, :input_path, "my_input/:year/:day.input"
  ```

  ## Session cookie

  In order to fetch your input, this task needs your advent of code session cookie. This can be
  obtained by investigating your cookies after logging in on the advent of code website. The
  cookie can be stored inside your `config/config.exs` file (e.g.
  `config, :advent_of_code_utils, :session, "<your cookie here>"`) or it can be passed as a
  command-line argument.  If no cookie is present, the input cannot be fetched.

  ## Example input

  The example input of a given day is fetched by parsing the challenge webpage of a given day and
  returning the first code example found on that page. This is generally the example input of that
  day. As this method is not foolproof, it is sometimes necessary to modify the example file by
  hand.

  If you do not wish to fetch example input, you can pass the `--no-example` flag to this task, or
  you can set `fetch_example?` to `false` in the `advent_of_code_utils` application configuration.

  ## Configuration

  ### Application environment

  The following [application configuration parameters](`Config`) can modify the behaviour of this
  task:

  - `session`: Advent of code sessions cookie.
  - `day`: Specify the day. Defaults to the current day.
  - `year`: Specify the year. Defaults to the current year.
  - `time_zone`: Specify the time-zone used to determine the local time. Defaults to the time zone
    of your computer.  Please refer to the [README](readme.html#time-zones) for additional
    information.
  - `input_path`: Determines where the input file is stored. Defaults to `"input/:year_:day.txt"`
  - `example_path`: Determines where the example input is stored. Defaults to
    `"input/:year_:day_example.txt"`

  ### Command-line arguments

  The options below take precedence over values defined in the application configuration.

  - `-s` or `--session`: Specify the session cookie.
  - `-d` or `--day`: Specify the day.
  - `-y` or `--year`: Specify the year.
  - `--no-example`: Do not fetch example input
  - `--example`: Fetch example input
  """
  @shortdoc "Fetch AOC input"
  use Mix.Task
  alias AOC.Helpers

  @impl true
  def run(args), do: args |> Helpers.parse_args!([:day, :year, :session, :example]) |> run_task()

  def run_task(opts) do
    example = Keyword.get(opts, :example, Helpers.app_env_val(:fetch_example?, true))
    session = opts[:session] || Helpers.app_env_val(:session, nil)
    year = opts[:year]
    day = opts[:day]

    input_path = Helpers.input_path(year, day)

    start_applications()

    if example do
      fetch_examples(session, year, day)
      |> Enum.each(fn {example, nth} ->
        do_if_file_does_not_exists(Helpers.example_path(year, day, nth), fn -> example end)
      end)
    end

    do_if_file_does_not_exists(input_path, fn -> fetch_input(session, year, day) end)
  end

  defp do_if_file_does_not_exists(path, fun) do
    if File.exists?(path) do
      Mix.shell().info([:yellow, "* skipping ", :reset, path, " (already exists)"])
    else
      contents = fun.()
      Mix.shell().info([:green, "* creating ", :reset, path])
      path |> Path.dirname() |> File.mkdir_p!()
      File.write(path, contents)
    end
  end

  defp fetch_examples(session, year, day) do
    case fetch(~c"#{Mix.Tasks.Aoc.url(year, day)}", cookie(session)) do
      {:ok, input} ->
        find_examples(input)

      :error ->
        Mix.raise("Could not fetch example input. Please ensure the challenge is available.")
    end
  end

  defp find_examples(html) do
    with {:ok, html} <- Floki.parse_document(html),
         code_nodes <- Floki.find(html, "pre code") do
      code_nodes
      |> Stream.map(&join_text/1)
      |> Stream.with_index()
    else
      _ ->
        Mix.shell().info([
          :red,
          "! ",
          :reset,
          "Something went wrong while parsing the challenge",
          "\n",
          :red,
          "! ",
          :reset,
          "Example input will be empty"
        ])

        []
    end
  end

  defp join_text(child) when is_binary(child), do: child

  defp join_text({_type, _attributes, children}) when is_list(children) do
    children
    # IO data does not need to be flattened
    |> Enum.map(&join_text/1)
  end

  defp join_text(other) do
    # do not break on unexpected tokens
    IO.warn(~s"element not recognized while parsing the challenge: #{IO.inspect(other)}")
    # in case of unrecognized tokens, do not output ":ok"
    []
  end

  defp fetch_input(nil, _, _) do
    Mix.raise("Could not fetch input: no session cookie was set")
  end

  defp fetch_input(session, year, day) do
    case fetch(~c"#{Mix.Tasks.Aoc.url(year, day)}/input", cookie(session)) do
      {:ok, input} ->
        input

      :error ->
        Mix.raise("""
        Could not fetch input. Please ensure:
        - Your session cookie is set up correctly
        - The challenge is available
        - There is an input today
        """)
    end
  end

  defp fetch(url, headers) do
    ca_path = Helpers.app_env_val(:ca_cert_path, "/etc/ssl/cert.pem")
    headers = [user_agent() | headers]

    opts =
      if(File.exists?(ca_path), do: [ssl: [verify: :verify_peer, cacertfile: ca_path]], else: [])

    resp = :httpc.request(:get, {url, headers}, opts, [])

    case resp do
      {:ok, {{~c"HTTP/1.1", 200, ~c"OK"}, _headers, body}} -> {:ok, body}
      _ -> :error
    end
  end

  @ua_name Mix.Project.config()[:app]
  @ua_version Mix.Project.config()[:version]
  @ua_contact "github.com/mathsaey/advent_of_code_utils by contact@mathsaey.be"
  @ua_charlist to_charlist("#{@ua_name}/#{@ua_version} #{@ua_contact}")

  defp user_agent, do: {~c"User-Agent", @ua_charlist}
  defp cookie(nil), do: []
  defp cookie(session), do: [{~c"Cookie", to_charlist("session=#{session}")}]

  defp start_applications do
    :ok = Application.ensure_started(:inets)
    :ok = Application.ensure_started(:crypto)
    :ok = Application.ensure_started(:asn1)
    :ok = Application.ensure_started(:public_key)
    :ok = Application.ensure_started(:ssl)
  end
end
