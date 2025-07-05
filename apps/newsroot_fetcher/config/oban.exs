import Config

config :newsroot_fetcher, Oban,
  repo: NewsrootCore.Repo,
  queues: [rss: 10, html: 10],
  plugins: [{Oban.Plugins.Cron, crontab: [{"*/5 * * * *", NewsrootFetcher.Worker.RSSWorker}]}]
