defmodule ExChat.Web.ChatRoomWebSocketHandler do

  @behaviour :cowboy_websocket_handler

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    state = nil
    {:ok, req, state}
  end

  def websocket_handle({:text, command_as_json}, req, state) do
    handle(from_json(command_as_json), req, state)
  end

  def websocket_handle(_message, req, state) do
    {:ok, req, state}
  end

  def websocket_info(message, req, state) do
    response = %{
      room: "default",
      message: message
    }

    {:reply, {:text, to_json(response)}, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  defp handle(%{"command" => "join"}, req, state) do
    :ok = ExChat.ChatRooms.join("default", self())

    response = %{
      room: "default",
      message: "welcome to the default chat room!"
    }

    {:reply, {:text, to_json(response)}, req, state}
  end

  defp handle(%{"room" => room, "message" => message}, req, state) do
    :ok = ExChat.ChatRooms.send(room, message)
    {:ok, req, state}
  end

  defp to_json(response), do: Poison.encode!(response)
  defp from_json(json), do: Poison.decode!(json)
end
