defmodule ExChat.UseCases.CreateChatRoomTest do
  use ExUnit.Case, async: true

  import Mock

  alias ExChat.ChatRooms
  alias ExChat.UseCases.CreateChatRoom

  test "return an error message when the room already exists" do
    with_mock(ChatRooms, create: fn(_) -> {:error, :already_exists} end) do
      result = CreateChatRoom.on("a room")

      assert result == {:error, "a room already exists"}
      assert called ChatRooms.create("a room")
    end
  end

  test "return an successful message when create a room" do
    with_mock(ChatRooms, create: fn(_) -> :ok end) do
      result = CreateChatRoom.on("a room")

      assert result == {:ok, "a room has been created!"}
      assert called ChatRooms.create("a room")
    end
  end
end