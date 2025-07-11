import Config

config :newsroot, ecto_repos: [Newsroot.Repo]

config :newsroot, Newsroot.Repo,
  database: System.get_env("DB_NAME") || "newsroot_dev",
  username: System.get_env("DB_USER") || "postgres",
  password: System.get_env("DB_PASS") || "postgres",
  hostname: System.get_env("DB_HOST") || "localhost"

config :newsroot, Oban,
  repo: Newsroot.Repo,
  queues: [rss: 10, html: 10, analysis: 10]

config :logger, level: :info
