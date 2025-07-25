defmodule Newsroot.Content.UserFeedSubscription do
  use Ash.Resource,
    otp_app: :newsroot,
    domain: Newsroot.Content

  actions do
    defaults [:read, :destroy, :create]
  end

  attributes do
    uuid_primary_key :id
    attribute :is_favorite, :boolean, default: false

    create_timestamp :subscribed_at

    attribute :user_id, :uuid do
      allow_nil? false
    end

    attribute :feed_id, :uuid do
      allow_nil? false
    end
  end

  relationships do
    belongs_to :user, Newsroot.Accounts.User do
      source_attribute :user_id
      primary_key? false
      allow_nil? false
    end

    belongs_to :feed, Newsroot.Content.Feed do
      source_attribute :feed_id
      primary_key? false
      allow_nil? false
    end
  end

  identities do
    identity :unique_subsciption, [:user_id, :feed_id]
  end
end
