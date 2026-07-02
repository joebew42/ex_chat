defmodule ExChat.Web.WebSocketController do
  if Code.ensure_loaded?(:cowboy_websocket) do
    @behaviour :cowboy_websocket
  end

  alias ExChat.UseCases.{ValidateAccessToken, SendMessageToChatRoom,
    CreateChatRoom, JoinChatRoom, SubscribeToUserSession}

  @default_ping_interval 30_000
  @default_idle_timeout 60_000

  def init(req, state) do
    access_token = access_token_from(req)

    case ValidateAccessToken.on(access_token) do
      {:ok, user_id} ->
        {:cowboy_websocket, req, user_id, %{idle_timeout: idle_timeout()}}
      {:error, :access_token_not_valid} ->
        {:ok, :cowboy_req.reply(400, req), state}
    end
  end

  def websocket_init(user_id) do
    SubscribeToUserSession.on(self(), user_id)
    schedule_ping()

    {:ok, user_id}
  end

  def websocket_handle({:text, command_as_json}, user_id) do
    case from_json(command_as_json) do
      {:error, _reason} -> {:ok, user_id}
      {:ok, command} -> handle(command, user_id)
    end
  end

  def websocket_handle(_message, user_id) do
    {:ok, user_id}
  end

  def websocket_info(:ping, user_id) do
    schedule_ping()
    {:reply, {:ping, ""}, user_id}
  end

  def websocket_info(message, user_id) do
    {:reply, {:text, to_json(message)}, user_id}
  end

  defp handle(%{"command" => "join", "room" => room}, user_id) do
    case JoinChatRoom.on(room, user_id) do
      :ok ->
        {:ok, user_id}
      {:error, message} ->
        {:reply, {:text, to_json(%{error: message})}, user_id}
    end
  end

  defp handle(command = %{"command" => "join"}, user_id) do
    handle(Map.put(command, "room", "default"), user_id)
  end

  defp handle(%{"room" => room, "message" => message}, user_id) do
    case SendMessageToChatRoom.on(message, room, user_id) do
      {:error, message} ->
        {:reply, {:text, to_json(%{ error: message })}, user_id}
      :ok ->
        {:ok, user_id}
    end
  end

  defp handle(%{"command" => "create", "room" => room}, user_id) do
    response = case CreateChatRoom.on(room) do
      {:ok, message} -> %{success: message}
      {:error, message} -> %{error: message}
    end

    {:reply, {:text, to_json(response)}, user_id}
  end

  defp handle(_not_handled_command, user_id), do: {:ok, user_id}

  defp to_json(response), do: Poison.encode!(response)
  defp from_json(json), do: Poison.decode(json)

  defp schedule_ping do
    Process.send_after(self(), :ping, ping_interval())
  end

  defp ping_interval do
    Application.get_env(:ex_chat, :ping_interval, @default_ping_interval)
  end

  defp idle_timeout do
    Application.get_env(:ex_chat, :idle_timeout, @default_idle_timeout)
  end

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
