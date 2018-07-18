defmodule ExChat.Web.Router do
  use Plug.Router

  plug Plug.Static, at: "/", from: :ex_chat

  plug :match
  plug :dispatch

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  def dispatch do
    [
      {:_, [
        {"/chat", ExChat.Web.WebSocketClient, []},
        {:_, Plug.Adapters.Cowboy.Handler, {__MODULE__, []}}
      ]}
    ]
  end
end
