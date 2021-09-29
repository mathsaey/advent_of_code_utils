defmodule Mix.Tasks.Aoc.Get do
  @moduledoc """
  Fetch the input of the AOC challenge for a given day / year.

  This mix task fetches the inputs for the advent of code challenge of a specific day. The day and
  year of the challenge can be passed as command-line arguments or be set in the
  `advent_of_code_utils` application configuration. When neither is present, the current date is
  used.

  By default, this task stores the fetched data in `input/<year>_<day>.txt`. If this file already
  exists, no input is fetched. The destination path can be modified by setting the value of
  `:input_path` in the `advent_of_code_utils` application. This value should be set to a string
  which may contain `:year` and `:day`. These values will be replaced by the day and year of
  which the input is fetched.

  For instance, the following configuration will store the fetched data in
  `my_input/<year>/<day>.input`:

  ```
  config :advent_of_code_utils, :code_path, "my_input/:year/:day.input"
  ```

  ## Session cookie

  In order to fetch your input, this task needs your advent of code session cookie. This can be
  obtained by investigating your cookies after logging in on the advent of code website. The
  cookie can be stored inside your `config/config.exs` file (e.g.
  `config, :advent_of_code_utils, :session, "<your cookie here>"`) or it can be passed as a
  command-line argument.  If no cookie is present, the input can not be fetched.

  ## Command-line arguments

  The options below take precedence over values defined in the application configuration.

  - `-s` or `--session`: Specify the session cookie.
  - `-y` or `--year`: Specify the year.
  - `-d` or `--day`: Specify the day.
  """
  @shortdoc "Fetch AOC input"
  use Mix.Task
  alias AOC.Helpers

  def run(args) do
    {session, year, day} = Helpers.parse_args!(args)
    path = Helpers.input_path(year, day)

    cond do
      File.exists?(path) ->
        Mix.shell().info([:yellow, "* Skipping ", :reset, path, " (already exists)"])

      session == nil ->
        Mix.raise("No session cookie was set")

      true ->
        fetch(session, year, day, path)
    end
  end

  defp fetch(session, year, day, path) do
    case get_input(session, year, day) do
      {:ok, input} ->
        Mix.shell().info([:green, "* Creating ", :reset, path])
        path |> Path.dirname() |> File.mkdir_p!()
        File.write(path, input)

      :error ->
        Mix.raise("""
        Could not fetch input. Please ensure:
        - Your session cookie is set up correctly
        - The challenge is available
        - There is an input today
        """)
    end
  end

  defp get_input(session, year, day) do
    start_applications()
    url = Mix.Tasks.Aoc.url(year, day)
    ca_path = Application.get_env(:advent_of_code_utils, :ca_cert_path, "/etc/sl/cert.pem")
    opts = if(File.exists?(ca_path), do: [ssl: [verify: :verify_peer, cacertfile: ca_path]], else: [])
    resp = :httpc.request(:get, {'#{url}/input', [cookie(session)]}, opts, [])

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

  defp cookie(session), do: {'Cookie', to_charlist("session=#{session}")}
end
