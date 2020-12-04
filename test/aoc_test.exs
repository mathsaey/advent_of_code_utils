defmodule AOCTest do
  use ExUnit.Case

  test "input_path/2" do
    assert AOC.input_path(1991, 8) == "test/input/1991_8.txt"
  end

  test "input_string/2" do
    assert AOC.input_string(1991, 8) == """
           first line
           second line
           """
  end

  test "input_stream/2" do
    assert AOC.input_stream(1991, 8) |> Enum.to_list() == ["first line", "second line"]
  end

  test "generated functions" do
    defmodule Test do
      use AOC, year: 1991, day: 8

      # input_* functions are private
      def path, do: input_path()
      def string, do: input_string()
      def stream, do: input_stream()
    end

    assert Test.path() == AOC.input_path(1991, 8)
    assert Test.string() == AOC.input_string(1991, 8)
    assert Test.stream() == AOC.input_stream(1991, 8)
  end

  test "aoc/3" do
    import AOC

    aoc 1991, 8 do
      def path, do: input_path()
      def string, do: input_string()
      def stream, do: input_stream()
    end

    assert Y1991.D8.path() == AOC.input_path(1991, 8)
    assert Y1991.D8.string() == AOC.input_string(1991, 8)
    assert Y1991.D8.stream() == AOC.input_stream(1991, 8)
  end
end
