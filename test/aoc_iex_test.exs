defmodule AOC.IExTest do
  use ExUnit.Case

  import AOC.IEx
  import AOC

  doctest AOC.IEx

  aoc 1991, 8 do
    def p1, do: :foo
    def p2, do: :bar
  end

  test "p1/2, p2/2" do
    assert p1(1991, 8) == :foo
    assert p2(1991, 8) == :bar
  end

  test "p1/1, p2/1" do
    Application.put_env(:advent_of_code_utils, :year, 1991)
    assert p1(8) == :foo
    assert p2(8) == :bar
  end

  test "p1/0, p2/0" do
    Application.put_env(:advent_of_code_utils, :year, 1991)
    Application.put_env(:advent_of_code_utils, :day, 8)
    assert p1() == :foo
    assert p2() == :bar
  end
end
