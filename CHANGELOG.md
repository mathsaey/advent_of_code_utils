# 2.0

# 2.0.2

- Pass user agent when using `mix aoc.get`

# 2.0.1

- Update ex_doc, add typepsecs to public functions.

# 2.0.0

- `input_string` and `example_string` now both call `String.trim_trailing/1` on
  the returned string.

## 1.1

### 1.1.0

- Download example input when using `mix aoc.get`.
- Add `example_*` functions to `AOC` module.

## 1.0

### 1.0.1

- Make `input_*` functions public (`def` instead of `defp`) to
  facilitate debugging.

### 1.0.0

- Initial stable release
