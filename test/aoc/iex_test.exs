defmodule AOC.IExTest do
  use AOCUtilsCase
  import AOC.IEx

  doctest AOC.IEx

  test "calls with fully specified date" do
    assert p1("foo", year: 1991, day: 8) == "foo"
    assert p2("bar", year: 1991, day: 8) == "bar"
  end

  test "calls with specified day" do
    Application.put_env(:advent_of_code_utils, :year, 1991)
    assert p1("foo", day: 8) == "foo"
    assert p2("bar", day: 8) == "bar"
  end

  test "calls with no extra arguments" do
    Application.put_env(:advent_of_code_utils, :year, 1991)
    Application.put_env(:advent_of_code_utils, :day, 8)
    assert p1("foo") == "foo"
    assert p2("bar") == "bar"
  end

  test "call with example input" do
    assert p1e(year: 1991, day: 8) == "example line"
    assert p2e(year: 1991, day: 8) == "example line"
  end

  test "call with puzzle input" do
    assert p1i(year: 1991, day: 8) == "input line"
    assert p2i(year: 1991, day: 8) == "input line"
  end

  test "input path" do
    assert input_path(year: 1991, day: 8) == "test/input/1991_8.txt"
    assert example_path(year: 1991, day: 8) == "test/example/1991_8.txt"
    Application.put_env(:advent_of_code_utils, :year, 2014)
    Application.put_env(:advent_of_code_utils, :day, 10)
    assert input_path() == "test/input/2014_10.txt"
    assert example_path() == "test/example/2014_10.txt"
  end

  test "input string" do
    assert input_string(year: 1991, day: 8) == "input line"
    assert example_string(year: 1991, day: 8) == "example line"
    Application.put_env(:advent_of_code_utils, :year, 1991)
    Application.put_env(:advent_of_code_utils, :day, 8)
    assert input_string() == "input line"
    assert example_string() == "example line"
  end
end
