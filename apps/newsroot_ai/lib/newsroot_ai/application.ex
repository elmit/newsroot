defmodule NewsrootAI.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Oban, Application.fetch_env!(:newsroot_ai, Oban)}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: __MODULE__)
  end
end
