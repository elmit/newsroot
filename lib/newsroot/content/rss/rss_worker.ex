defmodule Newsroot.Content.RSSWorker do
  use Oban.Worker,
    queue: :feeds,
    max_attempts: 3

  @impl AshOban.Worker
  def perform(%Oban.Job{args: %{"feed_id" => feed_id}}) do
    case Newsroot.Content.process_rss_feed(feed_id) do
      {:ok, feed} ->
        {:ok, %{feed_id: feed.id, status: "ok"}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
