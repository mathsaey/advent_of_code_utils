# Changelog

## 4.1.0

- Make `mix aoc.get` fetch and store each example input, not just the first
  (this is useful when several example are available or when part 2 supplies
  additional examples)
- Update `example_path/1` and `example_string/1` to accept an `:n` option to
  retrieve the n-th example (0-based).
- Update `AOC.Case` so that `example_path/1` and `example_string/1` optionally
  accept the index of the example to use.
- Remove warning on freshly generated aoc code about unused input.

## 4.0.1

- Make `mix aoc.gen` use `example_string()` instead of `example_input()`, which
  doesn't exist.

## 4.0.0

### Overview

#### Dropping support for helper functions in solution modules

This update makes the "puzzle input" method introduced in 3.0.0 the only way
to write solution modules. The old, "helper function" method is no longer
supported.

The helper function method worked as follows:

```
aoc year, day do
  def p1, do: input_string() |> # Solve puzzle
end
```

The puzzle input method works as follows:

```
aoc year, day do
  def p1(input), do: input |> # solve puzzle
end
```

Input is provided through the use of the helpers in `AOC.IEx`.

The input method is preferred as it makes it easier to test your solution using
different inputs without the need to modify any code. It also makes it
significantly easier to write tests for your solution module.

Users who wish to keep using the helper method are advised to stick to version
3 of Advent of Code Utils.

#### `aoc_test/4`

This update adds optional support for generating unit test modules for your
solution modules. You can now write:

```
aoc_test year, day do
end
```

Which will create an `ExUnit.Case` which tests your solution module. The
generated case will automatically call the doctests of your solution module.

`mix aoc.gen` can now also generate this test code and add doctests to your
solution module.

### Detailed Changelog

- Introduce `AOC.aoc_test/4`, `AOC.Case`.
- Update `mix aoc.gen` to generate unit test files
- Remove `example_path/1`, `input_path/1`, `example_string/1`,
  `input_string/1`, `example_stream/1`, `input_stream/1` from `AOC` module.
- Remove `example_stream/1`, `input_stream/1` from `AOC.IEx`.
- Rename `fetch_example` configuration to `fetch_example?` for consistency.

## 3.1.3

- Optionally show the elapsed time when calling a `p1`, `p2`, `p1i`, `p1e`,
  `p2i` and `p2e`. This is done when the `time_calls?` configuration option is
  set to true.

## 3.1.2

- `AOC.IEx.mod/1` now calls `Code.ensure_loaded!/1` to ensure the target module
  is loaded. This is done to prevent issues where `p1e` and `p1i` complain that
  the target module does not exist.

## 3.1.1

- `input_stream`, `input_string`, `example_stream` and `example_string` now
  only trim trailing newlines, not significant whitespace.

## 3.1.0

- Timezone support: the project now accepts a `time_zone` configuration setting
  which can be used to specify the time zone used by the input fetcher and iex
  helpers. This can be set to a time zone string, to `:aoc` or to `:local` (the
  default). `:local` uses the system time, as before, while `:aoc` uses the
  advent of code time zone (i.e. EST).

## 3.0.0

- `AOC.IEx` has been reworked.
  - All functions accept an `opts` keyword list used to specify year or day
    when needed.
  - `p1` and `p2` now accept puzzle input as an argument, making it easier to
    switch between different inputs or examples.
  - Introduce `p1e`, `p1i`, `p2e` and `p2i` to facilitate calling `p1` or `p2`
    with example or puzzle input.
  - Introduce wrapper functions `example_path/1`, `input_path/1`,
    `example_string/1`, `input_string/1`, `example_stream/1` and
    `input_stream/1` to facilitate experimentation inside iex.
- Update `AOC` documentation to reflect to new workflow.
- Update `mix aoc.gen` to generate a template more suited to new workflow.

## 2.0.2

- Pass user agent when using `mix aoc.get`

## 2.0.1

- Update ex_doc, add typespecs to public functions.

## 2.0.0

- `input_string` and `example_string` now both call `String.trim_trailing/1` on
  the returned string.

## 1.1.0

- Download example input when using `mix aoc.get`.
- Add `example_*` functions to `AOC` module.

## 1.0.1

- Make `input_*` functions public (`def` instead of `defp`) to
  facilitate debugging.

## 1.0.0

- Initial stable release
