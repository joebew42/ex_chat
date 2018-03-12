defmodule ExChat.Web.Http do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "hello world")
  end
end
