# Advent of Code Utils

Input fetching and boilerplate generation for [Advent of Code](https://adventofcode.com/).

The goal of this project is to eliminate most of the manual labor involved with
working on the yearly Advent of Code challenges.

As a sample, this is the workflow you'd use when working on the challenge of the
first of December 2020:

```
$ mix aoc
Creating code path: lib/2020/1.ex
Fetching input...
Stored input: input/2020_1.txt
Today's challenge can be found at: https://adventofcode.com/2020/day/1
```

Afterwards, `lib/2020/1.ex` will look as follows:

```elixir
import AOC

aoc 2020, 1 do

  def p1() do
  end

  def p2() do
  end
end
```

In this generated module, you access the contents of the fetched input by using
`input_path()`, `input_string()` or `input_stream()`.
While solving your challenge in `iex`, you can use the `AOC.p1()` and `AOC.p2()`
helpers to quickly test your solution so far.

All of this is configurable so that you can adjust this project to fit your own
workflow. Check out the [docs](https://hexdocs.pm/advent_of_code_utils) for
more information!

## Installation & Use

- Add `advent_of_code_utils` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:advent_of_code_utils, "~> 0.1.0"}
  ]
end
```

- Store your session cookie in `config/config.exs`. You can find this by
  inspecting your cookies after logging in to the advent of code website.

```elixir
config :advent_of_code_utils, session: "<your cookie>"
```

- Use `mix aoc` to work on today's challenge. The day and year of a challenge
  can be passed in various ways, so this project is still highly useful when
  you're catching up on older challenges.

