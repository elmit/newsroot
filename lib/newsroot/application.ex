defmodule Newsroot.Application do
  use Application

  def start(_type, _args) do
    port = Application.get_env(:newsroot, NewsrootWeb.Endpoint)
           |> Keyword.get(:http, [])
           |> Keyword.get(:port, 4000)

    children = [
      Newsroot.Repo,
      {Oban, Application.fetch_env!(:newsroot, Oban)},
      {Plug.Cowboy, scheme: :http, plug: NewsrootWeb.Router, options: [port: port]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Newsroot.Supervisor)
  end
end
