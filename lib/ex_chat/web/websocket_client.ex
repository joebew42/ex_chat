defmodule ExChat.Web.WebSocketClient do
  @behaviour :cowboy_websocket_handler

  alias ExChat.{UserSessions, ChatRooms}

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    UserSessions.subscribe(self(), to: "default-user-session")

    {:ok, req, "default-user-session"}
  end

  def websocket_handle({:text, command_as_json}, req, session_id) do
    case from_json(command_as_json) do
      {:error, _reason} -> {:ok, req, session_id}
      {:ok, command} -> handle(command, req, session_id)
    end
  end

  def websocket_handle(_message, req, session_id) do
    {:ok, req, session_id}
  end

  def websocket_info({:error, message}, req, session_id) do
    response = %{ error: message }

    {:reply, {:text, to_json(response)}, req, session_id}
  end

  def websocket_info({chatroom_name, message}, req, session_id) do
    response = %{
      room: chatroom_name,
      message: message
    }

    {:reply, {:text, to_json(response)}, req, session_id}
  end

  def websocket_info({_session_id, chatroom_name, message}, req, session_id) do
    response = %{
      room: chatroom_name,
      message: message
    }

    {:reply, {:text, to_json(response)}, req, session_id}
  end

  def websocket_terminate(_reason, _req, _session_id) do
    :ok
  end

  defp handle(%{"command" => "join", "room" => room}, req, session_id) do
    ChatRooms.join(room, as: session_id)

    {:ok, req, session_id}
  end

  defp handle(command = %{"command" => "join"}, req, session_id) do
    handle(Map.put(command, "room", "default"), req, session_id)
  end

  defp handle(%{"room" => room, "message" => message}, req, session_id) do
    case ChatRooms.send(message, to: room, as: session_id) do
      :ok ->
        {:ok, req, session_id}
      {:error, :unexisting_room} ->
        response = %{ error: room <> " does not exists" }
        {:reply, {:text, to_json(response)}, req, session_id}
    end
  end

  defp handle(%{"command" => "create", "room" => room}, req, session_id) do
    response = case ChatRooms.create(room) do
      :ok -> %{success: room <> " has been created!"}
      {:error, :already_exists} ->  %{error: room <> " already exists"}
    end

    {:reply, {:text, to_json(response)}, req, session_id}
  end

  defp handle(_not_handled_command, req, session_id), do: {:ok, req, session_id}

  defp to_json(response), do: Poison.encode!(response)
  defp from_json(json), do: Poison.decode(json)
end
