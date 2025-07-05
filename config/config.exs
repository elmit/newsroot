import Config

config :newsroot_core, ecto_repos: [NewsrootCore.Repo]

config :newsroot_core, NewsrootCore.Repo,
  database: System.get_env("DB_NAME") || "newsroot_dev",
  username: System.get_env("DB_USER") || "postgres",
  password: System.get_env("DB_PASS") || "postgres",
  hostname: System.get_env("DB_HOST") || "localhost"

config :newsroot_fetcher, Oban,
  repo: NewsrootCore.Repo,
  queues: [rss: 10, html: 10]

config :logger, level: :info
