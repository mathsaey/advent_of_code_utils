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

  describe "aoc_test" do
    import AOC

    test "generates tags on doctests" do
      aoc_test 2009, 12
      [%ExUnit.Test{tags: tags} | _] = Y2009.D12.AOCTest.__ex_unit__().tests
      assert {:date, ~D[2009-12-12]} in tags
      assert {:year, 2009} in tags
      assert {:day, 12} in tags
    end

    test "can add to body" do
      aoc_test 2009, 12 do
        def added_test_func, do: :works
      end

      assert Y2009.D12.AOCTest.added_test_func() == :works
    end

    test "inserted code can access helpers" do
      aoc_test 2009, 12 do
        def test_example_path, do: example_path()
      end

      assert Y2009.D12.AOCTest.test_example_path() == "test/example/2009_12.txt"
    end

    test "can modify ExUnit options" do
      aoc_test 2009, 12, exunit: [async: false] do
      end

      [%ExUnit.Test{tags: tags} | _] = Y2009.D12.AOCTest.__ex_unit__().tests
      assert tags.async == false
    end
  end
end
