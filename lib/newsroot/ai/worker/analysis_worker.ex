defmodule Newsroot.AI.Worker.AnalysisWorker do
  use Oban.Worker, queue: :analysis, max_attempts: 5

  @impl Oban.Worker
  def perform(_job) do
    :ok
  end
end
