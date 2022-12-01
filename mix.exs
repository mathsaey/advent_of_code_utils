defmodule AdventOfCodeUtils.MixProject do
  use Mix.Project

  @source_url "https://github.com/mathsaey/advent_of_code_utils/"

  def project do
    [
      app: :advent_of_code_utils,
      name: "Advent of Code Utils",
      version: "2.0.2",
      elixir: "~> 1.11",
      source_url: @source_url,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      dialyzer: dialyzer(),
      description: description()
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
      {:floki, "~> 0.34"}
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      authors: ["Mathijs Saey"],
      api_reference: false
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
      plt_add_apps: [:mix, :iex, :eex],
      plt_local_path: "_build/dialyzer/"
    ]
  end
end
