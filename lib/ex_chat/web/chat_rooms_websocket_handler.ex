defmodule ExChat.Web.ChatRoomsWebSocketHandler do
  @behaviour :cowboy_websocket_handler

  alias ExChat.{UserSessions, ChatRooms}

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    UserSessions.subscribe(self(), to: "default-user-session")

    {:ok, req, nil}
  end

  def websocket_handle({:text, command_as_json}, req, state) do
    case from_json(command_as_json) do
      {:error, _reason} -> {:ok, req, state}
      {:ok, command} -> handle(command, req, state)
    end
  end

  def websocket_handle(_message, req, state) do
    {:ok, req, state}
  end

  def websocket_info({:error, message}, req, state) do
    response = %{ error: message }

    {:reply, {:text, to_json(response)}, req, state}
  end

  def websocket_info({chatroom_name, message}, req, state) do
    response = %{
      room: chatroom_name,
      message: message
    }

    {:reply, {:text, to_json(response)}, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  defp handle(%{"command" => "join", "room" => room}, req, state) do
    ChatRooms.join(room, "default-user-session")

    {:ok, req, state}
  end

  defp handle(command = %{"command" => "join"}, req, state) do
    handle(Map.put(command, "room", "default"), req, state)
  end

  defp handle(%{"room" => room, "message" => message}, req, state) do
    case ChatRooms.send(room, message) do
      :ok ->
        {:ok, req, state}
      {:error, :unexisting_room} ->
        response = %{ error: room <> " does not exists" }
        {:reply, {:text, to_json(response)}, req, state}
    end
  end

  defp handle(%{"command" => "create", "room" => room}, req, state) do
    response = case ChatRooms.create(room) do
      :ok -> %{success: room <> " has been created!"}
      {:error, :already_exists} ->  %{error: room <> " already exists"}
    end

    {:reply, {:text, to_json(response)}, req, state}
  end

  defp handle(_not_handled_command, req, state), do: {:ok, req, state}

  defp to_json(response), do: Poison.encode!(response)
  defp from_json(json), do: Poison.decode(json)
end
