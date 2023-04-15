defmodule AOC.IExTest do
  use ExUnit.Case, async: true

  import AOC.IEx
  import AOC

  aoc 2000, 3 do
    def p1(input), do: input
    def p2(input), do: input
  end

  aoc 2014, 10 do
    def p1, do: :foo
    def p2, do: :bar
  end

  doctest AOC.IEx

  test "calls with fully specified date" do
    assert p1(nil, year: 2014, day: 10) == :foo
    assert p2(nil, year: 2014, day: 10) == :bar
  end

  test "calls with specified day" do
    Application.put_env(:advent_of_code_utils, :year, 2014)
    assert p1(nil, day: 10) == :foo
    assert p2(nil, day: 10) == :bar
  end

  test "calls with no extra arguments" do
    Application.put_env(:advent_of_code_utils, :year, 2014)
    Application.put_env(:advent_of_code_utils, :day, 10)
    assert p1() == :foo
    assert p2() == :bar
  end

  test "call undefined" do
    assert_raise ArgumentError, fn -> p1(nil, year: 2001, day: 3) end
    assert_raise ArgumentError, fn -> p2(nil, year: 2001, day: 3) end
  end

  test "call with example input" do
    assert p1e(year: 2000, day: 3) == "example"
    assert p2e(year: 2000, day: 3) == "example"
  end

  test "call with puzzle input" do
    assert p1i(year: 2000, day: 3) == "input"
    assert p2i(year: 2000, day: 3) == "input"
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
    assert input_string(year: 2000, day: 3) == "input"
    assert example_string(year: 2000, day: 3) == "example"
    Application.put_env(:advent_of_code_utils, :year, 2000)
    Application.put_env(:advent_of_code_utils, :day, 3)
    assert input_string() == "input"
    assert example_string() == "example"
  end

  test "input stream" do
    assert input_stream(year: 2000, day: 3) |> Enum.to_list() == ["input"]
    assert example_stream(year: 2000, day: 3) |> Enum.to_list() == ["example"]
    Application.put_env(:advent_of_code_utils, :year, 2000)
    Application.put_env(:advent_of_code_utils, :day, 3)
    assert input_stream() |> Enum.to_list() == ["input"]
    assert example_stream() |> Enum.to_list() == ["example"]
  end
end
