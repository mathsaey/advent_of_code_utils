defmodule AOC.HelpersTest do
  use AOCUtilsCase
  alias AOC.Helpers

  test "day without setting in application environment" do
    assert Helpers.day() == NaiveDateTime.local_now().day()
  end

  test "day when set in application environment" do
    put_env(:day, 42)
    assert Helpers.day() == 42
  end

  test "year without setting in application environment" do
    assert Helpers.year() == NaiveDateTime.local_now().year()
  end

  test "year when set in application environment" do
    put_env(:year, 1991)
    assert Helpers.year() == 1991
  end

  test "module names" do
    assert Helpers.module_name(1991, 8) == Y1991.D8
    assert Helpers.module_name(2009, 12) == Y2009.D12
  end

  test "test module names" do
    assert Helpers.test_module_name(1991, 8) == Y1991.D8.AOCTest
    assert Helpers.test_module_name(2009, 12) == Y2009.D12.AOCTest
  end

  @tag clear: :input_path
  test "input path" do
    assert Helpers.input_path(1991, 8) == "input/1991_8.txt"
    put_env(:input_path, ":day_:year_input")
    assert Helpers.input_path(1991, 8) == "8_1991_input"
  end

  @tag clear: :example_path
  test "example path" do
    assert Helpers.example_path(1991, 8) == "input/1991_8_example.txt"
    put_env(:example_path, ":day_:year_example")
    assert Helpers.example_path(1991, 8) == "8_1991_example"
  end

  @tag clear: :code_path
  test "code path" do
    assert Helpers.code_path(1991, 8) == "lib/1991/8.ex"
    put_env(:code_path, ":day_:year.ex")
    assert Helpers.code_path(1991, 8) == "8_1991.ex"
  end

  test "input string" do
    assert Helpers.input_string(1991, 8) == "input line"
  end

  test "example string" do
    assert Helpers.example_string(1991, 8) == "example line"
  end
end
