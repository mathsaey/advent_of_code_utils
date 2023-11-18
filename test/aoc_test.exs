defmodule AocTest do
  use AOCUtilsCase, async: true
  import AOC

  aoc 2009, 12 do
    def p1(_), do: nil
    def p2(_), do: nil
    def foo, do: :bar
  end

  test "module is generated with correct name" do
    assert Code.ensure_loaded(Y2009.D12)
  end

  test "aoc/3 does not modify body" do
    assert function_exported?(Y2009.D12, :p1, 1)
    assert function_exported?(Y2009.D12, :p2, 1)
    assert function_exported?(Y2009.D12, :foo, 0)
  end

  describe "aoc_test" do
    test "generates tags" do
      aoc_test 1991, 8 do
      end

      [%ExUnit.Test{tags: tags} | _] = Y1991.D8.AOCTest.__ex_unit__().tests
      assert {:aoc, "1991-8"} in tags
      assert {:year, 1991} in tags
      assert {:day, 8} in tags
    end

    test "can add functions to body" do
      aoc_test 1991, 8 do
        def foo, do: :bar
      end

      assert Y1991.D8.AOCTest.foo() == :bar
    end

    test "can add tests to body" do
      aoc_test 1991, 8 do
        test "foos the bar" do
        end
      end

      assert Enum.any?(Y1991.D8.AOCTest.__ex_unit__().tests, &(&1.name == :"test foos the bar"))
    end

    test "defines helpers" do
      aoc_test 1991, 8 do
      end

      assert Y1991.D8.AOCTest.input_path() == "test/input/1991_8.txt"
      assert Y1991.D8.AOCTest.example_path() == "test/example/1991_8.txt"
      assert Y1991.D8.AOCTest.input_string() == "input line"
      assert Y1991.D8.AOCTest.example_string() == "example line"
    end

    test "can modify ExUnit options" do
      aoc_test 1991, 8, async: true do
      end

      [%ExUnit.Test{tags: tags} | _] = Y1991.D8.AOCTest.__ex_unit__().tests
      assert tags.async == true
    end

    test "without doctest" do
      aoc_test 1991, 8, doctest?: false do
      end

      assert Enum.empty?(Y1991.D8.AOCTest.__ex_unit__().tests)
    end
  end
end
