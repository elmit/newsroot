defmodule Newsroot.Core.TopicEdge do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("topic_edges")
    repo(Newsroot.Repo)
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:from_id, :uuid)
    attribute(:to_id, :uuid)
  end
end
