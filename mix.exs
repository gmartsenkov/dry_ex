defmodule Dry.MixProject do
  use Mix.Project

  def project do
    [
      app: :dry,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      description: "Extend elixir structs",
      package: package()
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
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_spec, "~> 2.0", only: :test},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
    ]
  end

  defp aliases do
    [
      test: ["test", "credo"]
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "dry",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/gmartsenkov/dry_ex"}
    ]
  end
end
