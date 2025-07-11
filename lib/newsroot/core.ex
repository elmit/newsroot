defmodule Newsroot.Core do
  use Ash.Domain

  resources do
    resource Newsroot.Core.Article
    resource Newsroot.Core.TopicEdge
  end
end
