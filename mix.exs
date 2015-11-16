defmodule ExCloseio.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_closeio,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8"},
      {:poison, "~> 1.5"},

      {:exvcr, "~> 0.5", only: [:dev, :test]},
    ]
  end

  defp description do
     """
     Close.io client library for Elixir.
     """
  end

  defp package do
    [
      licenses: ["MIT"],
      keywords: ["Elixir", "Closeio", "Close.io", "client", "REST", "HTTP", "API"],
      maintainers: ["Taylor Brooks"],
      links: %{"GitHub" => "https://github.com/taylorbrooks/ex_closeio",
               "Docs" => "https://hexdocs.pm/ex_closeio"}
    ]
  end
end
