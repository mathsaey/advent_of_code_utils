# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  locals_without_parens: [aoc: 3, aoc_test: 4],
  export: [
    locals_without_parens: [aoc: 3, aoc_test: 4]
  ]
]
