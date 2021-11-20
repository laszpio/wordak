defmodule Wordak.MixProject do
  use Mix.Project

  def project do
    [
      app: :wordak,
      version: "0.1.0",
      elixir: "~> 1.8",
      escript: [main_module: Wordak],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.6.1", only: [:dev, :test], runtime: false}
    ]
  end
end
