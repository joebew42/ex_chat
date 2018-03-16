defmodule ExChat.Web.ChatRoomController do
  def chat_room(:init, state) do
    {:ok, state}
  end

  def chat_room(:terminate, _state) do
    :ok
  end

  def chat_room("join", state) do
    :ok = ExChat.ChatRoom.join(self())

    {:reply, {:text, "welcome to the awesome chat room!"}, state}
  end

  def chat_room(message, state) do
    :ok = ExChat.ChatRoom.send(message)
    {:ok, state}
  end
end
