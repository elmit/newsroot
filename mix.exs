defmodule Newsroot.MixProject do
  use Mix.Project

  def project do
    [
      app: :newsroot,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      mod: {Newsroot.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:ash, "~> 2.19"},
      {:ash_postgres, "~> 1.2"},
      {:oban, "~> 2.17"},
      {:plug_cowboy, "~> 2.6"},
      {:openai_ex, "~> 0.4"},
      {:jason, "~> 1.4"},
      {:nimble_csv, "~> 1.2"},
      {:req, "~> 0.4"},
      {:finch, "~> 0.16"}
    ]
  end

  defp aliases do
    [
      setup: [
        "deps.get",
        "ecto.setup",
        "cmd npm install --prefix priv/assets"
      ],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
