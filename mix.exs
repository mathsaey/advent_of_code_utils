defmodule AdventOfCodeUtils.MixProject do
  use Mix.Project

  @source_url "https://github.com/mathsaey/advent_of_code_utils/"

  def project do
    [
      app: :advent_of_code_utils,
      name: "Advent of Code Utils",
      version: "3.1.3",
      elixir: "~> 1.11",
      source_url: @source_url,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      dialyzer: dialyzer(),
      description: description(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp description do
    """
    Input fetching and boilerplate generation for Advent of Code challenges.
    """
  end

  def application do
    [
      extra_applications: [:inets, :iex, :eex]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:floki, "~> 0.34"},
      {:tz, "~> 0.26"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md", "CHANGELOG.md", "cheatsheet.cheatmd"],
      authors: ["Mathijs Saey"],
      source_ref: "master"
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{GitHub: @source_url}
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:mix, :iex, :eex, :ex_unit],
      plt_local_path: "_build/dialyzer/"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
