defmodule TextSite.MixProject do
  use Mix.Project

  def project do
    [
      app: :text_site,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TextSite.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:thousand_island, "~> 1.0-pre"},
      {:tzdata, "~> 1.1"}
    ]
  end
end
