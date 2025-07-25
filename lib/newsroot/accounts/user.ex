defmodule Newsroot.Accounts.User do
  use Ash.Resource,
    otp_app: :newsroot,
    domain: Newsroot.Accounts

  actions do
    defaults [:read, update: []]
  end

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      constraints match: ~r/^[^\s]+@[^\s]+$/
    end

    attribute :password_hard, :string, sensitive?: true

    attribute :preferences, :map, default: %{}

    attribute :is_active, :boolean, default: true
    attribute :is_admin, :boolean, default: false
    timestamps()
  end

  relationships do
    many_to_many :subscribed_to, Newsroot.Content.Feed do
      through Newsroot.Content.UserFeedSubscription
      source_attribute_on_join_resource :user_id
      destination_attribute_on_join_resource :feed_id
    end

    has_many :subscriptions, Newsroot.Content.UserFeedSubscription do
      destination_attribute :user_id
    end
  end

  identities do
    identity :unique_email, [:email]
  end

  identities do
    identity :unique_email, [:email]
  end
end
