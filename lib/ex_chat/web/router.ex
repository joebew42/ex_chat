defmodule ExChat.Web.Router do
  use Plug.Router

  alias ExChat.UseCases.CreateUser

  plug Plug.Static, at: "/", from: :ex_chat

  plug :match

  plug Plug.Parsers,
    parsers: [:json],
    json_decoder: Poison

  plug :dispatch

  post "/users" do
    case conn.body_params do
      %{"username" => username} when username != "" ->
        case CreateUser.on(username) do
          {:ok, result} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(201, Poison.encode!(result))
          {:error, message} ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(409, Poison.encode!(%{error: message}))
        end
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Poison.encode!(%{error: "username is required"}))
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end

  def dispatch do
    [
      {:_, [
        {"/chat", ExChat.Web.WebSocketController, []},
        {:_, Plug.Adapters.Cowboy2.Handler, {__MODULE__, []}}
      ]}
    ]
  end
end
