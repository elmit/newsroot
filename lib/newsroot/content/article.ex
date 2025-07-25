defmodule Newsroot.Content.Article do
  use Ash.Resource,
    otp_app: :newsroot,
    domain: Newsroot.Content

  actions do
    defaults [:read, :update]
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :original_url, :string do
      allow_nil? false

      constraints match: ~r/^https?:\/\//,
                  trim?: true
    end

    attribute :title, :string, allow_nil?: false
    attribute :raw_body, :string

    # markdown version should be saved here
    attribute :body, :string

    attribute :published_at, :utc_datetime_usec

    attribute :retrieved_at, :utc_datetime_usec do
      default &DateTime.utc_now/0
    end

    attribute :source_hash, :string, allow_nil?: false
    attribute :preview, :string
    timestamps()
  end

  relationships do
    belongs_to :feed, Newsroot.Content.Feed, allow_nil?: false
  end

  identities do
    identity :unique_source, [:source_hash]
  end
end
