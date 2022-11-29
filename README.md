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
  def p1 do
  end

  def p2 do
  end
end
```

In this generated module, you can access the contents of the fetched input by
using `input_path/0`, `input_string/0` or `input_stream/0`.  Example input is
available through `example_path/0`, `example_string/0` or `example_stream/0`.
While solving your challenge, you can use the `AOC.IEx.p1/0` and `AOC.IEx.p2/0`
helpers in `iex` to quickly test your solution so far.  These helpers can also
be set up to automatically recompile your mix project.

All of this is configurable so that you can adjust this project to fit your own
workflow. Check out the [docs](https://hexdocs.pm/advent_of_code_utils/) for
more information!

## Installation & Use

- Add `advent_of_code_utils` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:advent_of_code_utils, "~> 2.0"}
  ]
end
```

- Store your session cookie in `config/config.exs`. You can find this by
  inspecting your cookies after logging in to the advent of code website.

```elixir
config :advent_of_code_utils, session: "<your cookie>"
```

- Use `mix aoc` to work on today's challenge. The day and year of a challenge
  can be passed in various ways, so this project can still be used when working
  on older challenges.

  - If you just want to use this application to fetch the input of a challenge,
    without generating any code, use `mix aoc.get` instead of `mix aoc` and
    ignore the following steps.

  - You probably want to add `input/` to your `.gitignore` file if you use git.

- Add `import AOC.IEx` to your
  [`.iex.exs` file](https://hexdocs.pm/iex/IEx.html#module-the-iex-exs-file).
  This allows you to use the utilities defined in `AOC.IEx` without
  specifying the module name. _(optional)_

- Set `auto_compile?` in your `config/config.exs` if you want the various
  `AOC.p*` to recompile your project _(optional)_:
```elixir
config :advent_of_code_utils, auto_compile?: true
```

## Example Input

Besides fetching input, `mix aoc.get` and `mix aoc` will also fetch example
input for the given day.
This is done by reading the first code example on the challenge webpage, which
is generally that day's example input.

Since this method is not 100% reliable, you may you wish to disable this
behaviour.
This can be done by passing the `--no-example` flag to `mix aoc` or `mix
aoc.get` or by setting `fetch_example` to false in your `config.exs` file.

## Issues

This project grew from a collection of utilities I wrote for myself when working
on advent of code.
I polished these utilities, but it is possible some bugs are still present.
If you run into any issue, feel free to create an issue on
[GitHub](https://github.com/mathsaey/advent_of_code_utils).
