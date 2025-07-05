import Config

config :newsroot_web, NewsrootWeb.Endpoint,
  http: [port: String.to_integer(System.get_env("PORT") || "4000")],
  url: [host: System.get_env("HOST") || "localhost", port: 4000]
