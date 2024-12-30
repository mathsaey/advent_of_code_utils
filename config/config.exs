import Config

case Mix.env() do
  :test ->
    config :advent_of_code_utils,
      input_path: "test/input/:year_:day.txt",
      example_path: "test/example/:year_:day_:n.txt",
      code_path: "test/generated/:year/:day.ex"

  _ ->
    nil
end
