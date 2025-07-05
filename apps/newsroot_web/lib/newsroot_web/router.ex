defmodule NewsrootWeb.Router do
  use Plug.Router

  plug Plug.Static,
    at: "/",
    from: {:newsroot_web, "priv/assets"},
    only: ~w(index.html main.js sw.js manifest.json offline.html)

  plug :match
  plug :dispatch

  get "/" do
    conn |> Plug.Conn.send_file(200, asset("index.html"))
  end

  match _ do
    send_resp(conn, 404, "Not found")
  end

  defp asset(file), do: Path.join(:code.priv_dir(:newsroot_web), "assets/" <> file)
end
