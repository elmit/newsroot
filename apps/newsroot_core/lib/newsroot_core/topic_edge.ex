defmodule NewsrootCore.TopicEdge do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("topic_edges")
    repo(NewsrootCore.Repo)
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:from_id, :uuid)
    attribute(:to_id, :uuid)
  end
end
