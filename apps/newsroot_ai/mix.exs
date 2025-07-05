defmodule NewsrootAI.MixProject do
  use Mix.Project

  def project do
    [
      app: :newsroot_ai,
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
      mod: {NewsrootAI.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ash, "~> 2.19"},
      {:oban, "~> 2.17"},
      {:openai_ex, "~> 0.4"}
    ]
  end
end
