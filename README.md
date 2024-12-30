# Advent of Code Utils

[![hex.pm](https://img.shields.io/hexpm/v/advent_of_code_utils.svg)](https://hex.pm/packages/advent_of_code_utils)
[![hexdocs.pm](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/advent_of_code_utils/)
[![hex.pm](https://img.shields.io/hexpm/l/advent_of_code_utils.svg)](https://hex.pm/packages/advent_of_code_utils)

Input fetching and boilerplate generation for [Advent of Code](https://adventofcode.com/).

The goal of this project is to eliminate most of the manual labor involved with
working on the yearly Advent of Code challenges.

As a sample, this is the workflow you'd use when working on the challenge of the
first of December 2020:

```
$ mix aoc
* Creating: lib/2020/1.ex
* Creating: input/2020_1.txt
* Creating: input/2020_1_example_0.txt
Today's challenge can be found at: https://adventofcode.com/2020/day/1
```

Afterwards, `lib/2020/1.ex` will look as follows:

```elixir
import AOC

aoc 2020, 1 do
  def p1(input) do
    input
  end

  def p2(input) do
    input
  end
end
```

While solving your challenge, you can use the `AOC.IEx.p1e/1` and
`AOC.IEx.p2e/1` helpers in `iex` to test your solution so far with the example
input(s). Once ready, you can use `AOC.IEx.p1i/1` and `AOC.IEx.p2i/1` to run
your solution on your puzzle input.

The project also optionally supports automatically recompiling your mix project
when using the aforementioned helpers, timing your solutions, and boilerplate
generation for unit testing your solution modules. It also supports working on
puzzles from previous days or years. Check out the
[docs](https://hexdocs.pm/advent_of_code_utils/) or the
[cheatsheet](https://hexdocs.pm/advent_of_code_utils/cheatsheet.html) for more
information.

## Setup & Use

- Add `advent_of_code_utils` to your list of dependencies in `mix.exs`:
  ```elixir
  def deps do
    [
      {:advent_of_code_utils, "~> 5.0"}
    ]
  end
  ```

- Configure your Advent of Code project in `config/config.exs`:

  - Store your session cookie. You can find this by inspecting your cookies
    after logging in to the advent of code website.

    ```elixir
    config :advent_of_code_utils, session: "<your cookie>"
    ```

  - _(Optional)_ Set `auto_compile?` to `true` if you want the various `AOC.IEx.p*` helpers
    to recompile your project:

    ```elixir
    config :advent_of_code_utils, auto_compile?: true
    ```

  - _(Optional)_ Set `time_calls?` to `true` if you want the various `AOC.IEx.p*` helpers
    to show the runtime of calling a solution.

    ```elixir
    config :advent_of_code_utils, time_calls?: true
    ```

  - _(Optional)_ Set `gen_tests?` to `true` if you want `mix aoc.gen` to
    generate unit test code.

    ```elixir
    config :advent_of_code_utils, gen_tests?: true
    ```

  - _(Optional)_ Configure `iex` to display charlists as lists. This will prevent lists like
    `[99, 97, 116]` to show up as `'cat'`:

    ```elixir
    config :iex, inspect: [charlists: :as_lists]
    ```

  - If you follow these steps, your `config/config.exs` should look as follows:

    ```elixir
    import Config

    config :advent_of_code_utils,
      auto_compile?: true,
      time_calls?: true,
      gen_tests?: true,
      session: "<your session cookie>"

    config :iex,
      inspect: [charlists: :as_lists]
    ```

- _(Optional)_ Add `import AOC.IEx` to your
  [`.iex.exs` file](https://hexdocs.pm/iex/IEx.html#module-the-iex-exs-file).
  This allows you to use the utilities defined in `AOC.IEx` without
  specifying the module name.

- _(Optional)_ Add `input/` to your `.gitignore` file if you use git.

Now that you are set up, you can use `mix aoc` to work on today's challenge.
The day and year of a challenge can be passed in various ways, so this project
can still be used when working on older challenges.

If you only want to use this application to fetch the input of a challenge
without generating any code, you can skip most of the optional steps above and
use `mix aoc.get` instead of `mix aoc`.

## Example Input

Besides fetching input, `mix aoc.get` and `mix aoc` will also fetch example
input for the given day.  This is done by reading each code example on the
challenge webpage and storing each with a progressive number (starting from 0).

Since this method is not 100% reliable, you may you wish to disable this
behaviour. This can be done by passing the `--no-example` flag to `mix aoc` or
`mix aoc.get` or by setting `fetch_example?` to false in your `config.exs`
file.

## Time Zones

By default, this project uses your system time (as determined by
`NaiveDateTime.local_now/0`), to determine the current "day". Said otherwise,
if your computer says it is currently the 8th of December, `mix aoc.get`,
`AOC.IEx.p1/2`, and other functions which reason about time will assume it is
the 8th day of December. This can be problematic if you live in a time zone
which does not align well with the publication time of the AOC puzzles
(midnight US Eastern Standard Time).

This problem can be solved by setting the `time_zone` option of
`advent_of_code_utils`. When this option is set to `:aoc`, the project will
determine the current day based on EST, the time zone of the advent of code
servers. When it is said to `:local` (the default), your system time will be
used. Alternatively, a valid time zone string can be supplied, in which case
the project will determine the current day based on the provided time zone.

```elixir
# Use the aoc timezone instead of local time
config :advent_of_code_utils, time_zone: :aoc
```

## Issues

This project grew from a collection of utilities I wrote for myself when working
on advent of code.
I polished these utilities, but it is possible some bugs are still present.
If you run into any issue, feel free to create an issue on
[GitHub](https://github.com/mathsaey/advent_of_code_utils).

## AoC Automation Guidelines

This tool follows the [automation guidelines](https://www.reddit.com/r/adventofcode/wiki/faqs/automation)
on the /r/adventofcode community wiki. The following information is intended to
specify how we follow these guidelines:

* All code that communicates with the AoC servers is located in
  `lib/mix/tasks/aoc.get.ex`.
* This tool only communicates with the AoC servers at the request of the user
  (i.e. when they use `mix aoc.get` or `mix aoc`).
* Fetched inputs are stored locally and are never retrieved again unless the
  user deletes the retrieved file manually (`do_if_file_does_not_exist/2`).
* The `User-Agent` header is set in `fetch/2` and contains my personal contact
  information and a reference to this repository.
