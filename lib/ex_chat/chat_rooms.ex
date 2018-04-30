defmodule ExChat.ChatRooms do
  def join(_room_name, subscriber) do
    ExChat.ChatRoom.join(subscriber)
  end

  def send(_room_name, message) do
    ExChat.ChatRoom.send(message)
  end
end
