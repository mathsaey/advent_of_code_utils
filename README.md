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
* Creating: input/2020_1_example.txt
Today's challenge can be found at: https://adventofcode.com/2020/day/1
```

Afterwards, `lib/2020/1.ex` will look as follows:

```elixir
import AOC

aoc 2020, 1 do
  def p1(input) do
  end

  def p2(input) do
  end
end
```

While solving your challenge, you can use the `AOC.IEx.p1e/1` and
`AOC.IEx.p2e/1` helpers in `iex` to test your solution so far with the example
input. Once ready, you can use `AOC.IEx.p1i/1` and `AOC.IEx.p2i/1` to run your
solution on your puzzle input. These helpers can also be set up to
automatically recompile your mix project.

All of this is configurable so that you can adjust this project to fit your own
workflow. For instance, you can forego the `iex` helpers, and instead access
the contents of the fetched input by using `input_path/0`, `input_string/0` or
`input_stream/0`. Example input is available through `example_path/0`,
`example_string/0` or `example_stream/0`.
Check out the [docs](https://hexdocs.pm/advent_of_code_utils/) for
more information!

## Setup & Use

- Add `advent_of_code_utils` to your list of dependencies in `mix.exs`:
  ```elixir
  def deps do
    [
      {:advent_of_code_utils, "~> 3.0"}
    ]
  end
  ```

- Configure your Advent of Code project in `config/config.exs`:

  - Store your session cookie in `config/config.exs`. You can find this by
    inspecting your cookies after logging in to the advent of code website.

    ```elixir
    config :advent_of_code_utils, session: "<your cookie>"
    ```

  - _(Optional)_ Set `auto_compile?` to `true` if you want the various `AOC.IEx.p*` helpers
    to recompile your project:

    ```elixir
    config :advent_of_code_utils, auto_compile?: true
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

If you only want to use this application to fetch the input of  challenge,
without generating any code, you can use `mix aoc.get` instead of `mix aoc`.
Additionally, you can skip most of the optional steps above.

## Example Input

Besides fetching input, `mix aoc.get` and `mix aoc` will also fetch example
input for the given day.  This is done by reading the first code example on the
challenge webpage, which is generally that day's example input.

Since this method is not 100% reliable, you may you wish to disable this
behaviour. This can be done by passing the `--no-example` flag to `mix aoc` or
`mix aoc.get` or by setting `fetch_example` to false in your `config.exs` file.

## Issues

This project grew from a collection of utilities I wrote for myself when working
on advent of code.
I polished these utilities, but it is possible some bugs are still present.
If you run into any issue, feel free to create an issue on
[GitHub](https://github.com/mathsaey/advent_of_code_utils).
