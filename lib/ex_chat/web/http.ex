defmodule ExChat.Web.Http do
  use Plug.Router
  use WebSocket

  socket "/echo", ExChat.Web.EchoController, :echo

  plug Plug.Static, at: "/", from: :ex_chat

  plug :match
  plug :dispatch

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
