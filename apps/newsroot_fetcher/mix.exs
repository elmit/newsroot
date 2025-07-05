defmodule NewsrootFetcher.MixProject do
  use Mix.Project

  def project do
    [
      app: :newsroot_fetcher,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {NewsrootFetcher.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ash, "~> 2.19"},
      {:oban, "~> 2.17"},
      {:req, "~> 0.4"},
      {:finch, "~> 0.16"}
    ]
  end
end
