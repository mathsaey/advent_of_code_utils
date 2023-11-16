# Changelog

## 4.0.0

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
