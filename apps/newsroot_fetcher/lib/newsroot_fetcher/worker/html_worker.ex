defmodule NewsrootFetcher.Worker.HTMLWorker do
  use Oban.Worker, queue: :html, max_attempts: 5

  @impl Oban.Worker
  def perform(_job) do
    :ok
  end
end
