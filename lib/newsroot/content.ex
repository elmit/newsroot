defmodule Newsroot.Content do
  use Ash.Domain,
    otp_app: :newsroot

  resources do
    resource Newsroot.Content.Feed
    resource Newsroot.Content.Article
    resource Newsroot.Content.UserFeedSubscription
  end

  def process_rss_feed(feed_id) do
    feed = Ash.Query.filter(feed_id == feed_id)

    with {:ok, updated_feed} <- Ash.update(feed, :process_rss) do
      {:ok, updated_feed}
    end
  end

  def get_rss_feeds_to_process do
    Feed
    |> Ash.read!(action: :pending_rss_fetch)
  end
end
