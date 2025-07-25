defmodule Newsroot.Content.RSSFetcher do
  def fetch(url) do
    with {:ok, response} <- http_client().get(url),
         {:ok, parsed} <- parse_rss(response.body) do
      {:ok, parsed}
    end
  end

  def parse_rss(content) do
    # Используем библиотеку для парсинга
    case FastRSS.parse(content) do
      {:ok, %{entries: entries}} ->
        articles = Enum.map(entries, &transform_entry/1)
        {:ok, articles}

      error ->
        error
    end
  end

  defp transform_entry(entry) do
    %{
      title: entry.title,
      url: entry.link,
      content: entry.content || entry.summary,
      published_at: entry.published,
      guid: entry.id || entry.link
    }
  end

  defp http_client do
    Application.get_env(:newsroot, :http_client, HTTPoison)
  end
end
