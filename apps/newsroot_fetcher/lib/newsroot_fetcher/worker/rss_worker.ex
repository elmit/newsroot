defmodule NewsrootFetcher.Worker.RSSWorker do
  use Oban.Worker, queue: :rss, max_attempts: 5

  @impl Oban.Worker
  def perform(_job) do
    :ok
  end
end
