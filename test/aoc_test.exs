defmodule AOCTest do
  use ExUnit.Case, async: true

  test "input_path/2" do
    assert AOC.input_path(1991, 8) == "test/input/1991_8.txt"
  end

  test "example_path/2" do
    assert AOC.example_path(1991, 8) == "test/example/1991_8.txt"
  end

  test "input_string/2" do
    assert AOC.input_string(1991, 8) == """
           first line
           second line\
           """
  end

  test "example_string/2" do
    assert AOC.example_string(1991, 8) == """
           example line
           other line\
           """
  end

  test "input_stream/2" do
    assert AOC.input_stream(1991, 8) |> Enum.to_list() == ["first line", "second line"]
  end

  test "example_stream/2" do
    assert AOC.example_stream(1991, 8) |> Enum.to_list() == ["example line", "other line"]
  end

  test "generated functions" do
    defmodule Test do
      use AOC, year: 1991, day: 8
    end

    assert Test.input_path() == AOC.input_path(1991, 8)
    assert Test.input_string() == AOC.input_string(1991, 8)
    assert Test.input_stream() == AOC.input_stream(1991, 8)

    assert Test.example_path() == AOC.example_path(1991, 8)
    assert Test.example_string() == AOC.example_string(1991, 8)
    assert Test.example_stream() == AOC.example_stream(1991, 8)
  end

  test "aoc/3" do
    import AOC

    aoc 1991, 8 do
    end

    assert Y1991.D8.input_path() == AOC.input_path(1991, 8)
    assert Y1991.D8.input_string() == AOC.input_string(1991, 8)
    assert Y1991.D8.input_stream() == AOC.input_stream(1991, 8)

    assert Y1991.D8.example_path() == AOC.example_path(1991, 8)
    assert Y1991.D8.example_string() == AOC.example_string(1991, 8)
    assert Y1991.D8.example_stream() == AOC.example_stream(1991, 8)
  end
end
