defmodule Newsroot.Content.Feed do
  use Ash.Resource,
    otp_app: :newsroot,
    domain: Newsroot.Content

  actions do
    defaults [:read, :destroy]

    read :pending_rss_fetch do
      prepare fn query, _context ->
        query
        |> Ash.Query.filter(
          expr(
            is_active == true and
              (is_nil(last_fetched_at) or
                 fragment(
                   "? + interval '1 minute' * ? < now()",
                   last_fetched_at,
                   fetch_interval_minutes
                 ))
          )
        )
      end
    end

    update :process_rss do
      accept []
      # TODO: make it with module: https://hexdocs.pm/ash/changes.html#custom-changes
      change fn changeset, _context ->
        feed = changeset.data

        with {:ok, articles} <- Newsroot.Content.RSSFetcher.fetch(feed.url),
             {:ok, result} <-
               Newsroot.Content.RSSArticleImporter.import(feed, articles) do
          changeset
          |> Ash.Changeset.change_attribute(:last_fetched_at, DateTime.utc_now())
          |> Ash.Changeset.change_attribute(:failure_count, 0)
          |> Ash.Changeset.change_attribute(:last_article_count, result.total_count)
        else
          {:error, reason} ->
            changeset
            |> Ash.Changeset.change_attribute(:failure_count, (feed.failure_count || 0) + 1)
            |> Ash.Changeset.add_error(field: :base, message: "Failed to fetch RSS")
        end
      end
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :url, :string do
      allow_nil? false

      constraints match: ~r/^https?:\/\//,
                  trim?: true
    end

    attribute :name, :string, allow_nil?: false
    attribute :icon_url, :string
    attribute :description, :string

    attribute :source_type, :atom do
      default :rss
      constraints one_of: [:rss, :telegram]
    end

    attribute :is_active, :boolean, default: true
    attribute :last_fetched_at, :utc_datetime
    attribute :failure_count, :integer, default: 0

    attribute :metadata, :map do
      default %{}
    end

    timestamps()
  end

  relationships do
    has_many :articles, Newsroot.Content.Article do
      destination_attribute :feed_id
    end

    many_to_many :subscribers, Newsroot.Accounts.User do
      through Newsroot.Content.UserFeedSubscription
      source_attribute_on_join_resource :feed_id
      destination_attribute_on_join_resource :user_id
    end
  end
end
