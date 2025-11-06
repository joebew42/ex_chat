defmodule ExChat.UseCases.SendMessageToChatRoomTest do
  use ExUnit.Case, async: true

  import Mock

  alias ExChat.Rooms
  alias ExChat.UseCases.SendMessageToChatRoom

  test "return an error message when the room does not exists" do
    with_mock(Rooms, send: fn(_, _) -> {:error, :unexisting_room} end) do
      result = SendMessageToChatRoom.on("a message", "a room", "a user id")

      assert result == {:error, "a room does not exists"}
      assert called Rooms.send("a message", to: "a room", as: "a user id")
    end
  end

  test "return ok when send a message" do
    with_mock(Rooms, send: fn(_, _) -> :ok end) do
      result = SendMessageToChatRoom.on("a message", "a room", "a user id")

      assert result == :ok
      assert called Rooms.send("a message", to: "a room", as: "a user id")
    end
  end
end