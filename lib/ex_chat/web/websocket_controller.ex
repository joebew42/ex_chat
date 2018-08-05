defmodule ExChat.Web.WebSocketController do
  @behaviour :cowboy_websocket

  alias ExChat.UseCases.{ValidateAccessToken, SendMessageToChatRoom,
    CreateChatRoom, JoinChatRoom, SubscribeToUserSession}

  def init(req, state) do
    access_token = access_token_from(req)

    case ValidateAccessToken.on(access_token) do
      {:ok, user_session} ->
        {:cowboy_websocket, req, user_session, %{idle_timeout: 1000 * 60 * 10}}
      {:error, :access_token_not_valid} ->
        {:ok, :cowboy_req.reply(400, req), state}
    end
  end

  def websocket_init(user_session) do
    SubscribeToUserSession.on(self(), user_session)

    {:ok, user_session}
  end

  def websocket_handle({:text, command_as_json}, session_id) do
    case from_json(command_as_json) do
      {:error, _reason} -> {:ok, session_id}
      {:ok, command} -> handle(command, session_id)
    end
  end

  def websocket_handle(_message, session_id) do
    {:ok, session_id}
  end

  def websocket_info(message, session_id) do
    {:reply, {:text, to_json(message)}, session_id}
  end

  defp handle(%{"command" => "join", "room" => room}, session_id) do
    case JoinChatRoom.on(room, session_id) do
      :ok ->
        {:ok, session_id}
      {:error, message} ->
        {:reply, {:text, to_json(%{error: message})}, session_id}
    end
  end

  defp handle(command = %{"command" => "join"}, session_id) do
    handle(Map.put(command, "room", "default"), session_id)
  end

  defp handle(%{"room" => room, "message" => message}, session_id) do
    case SendMessageToChatRoom.on(message, room, session_id) do
      {:error, message} ->
        {:reply, {:text, to_json(%{ error: message })}, session_id}
      :ok ->
        {:ok, session_id}
    end
  end

  defp handle(%{"command" => "create", "room" => room}, session_id) do
    response = case CreateChatRoom.on(room) do
      {:ok, message} -> %{success: message}
      {:error, message} -> %{error: message}
    end

    {:reply, {:text, to_json(response)}, session_id}
  end

  defp handle(_not_handled_command, session_id), do: {:ok, session_id}

  defp to_json(response), do: Poison.encode!(response)
  defp from_json(json), do: Poison.decode(json)

  defp access_token_from(req) do
    query_parameter =
      :cowboy_req.parse_qs(req)
      |> Enum.find(fn({key, _value}) -> key == "access_token" end)

    case query_parameter do
      {"access_token", access_token} -> access_token
      _ -> nil
    end
  end
end
