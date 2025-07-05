defmodule NewsrootCore.Article do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("articles")
    repo(NewsrootCore.Repo)
  end

  attributes do
    uuid_primary_key(:id)
    attribute(:title, :string)
    attribute(:body_path, :string)
  end
end
