defmodule ExChat.UseCases.JoinChatRoomTest do
  use ExUnit.Case, async: true

  import Mock

  alias ExChat.{ChatRooms, UserSessions}
  alias ExChat.UseCases.JoinChatRoom

  test "return an error message when the chat room does not exists" do
    with_mocks([
      {ChatRooms, [], join: fn(_, _) -> {:error, :unexisting_room} end},
      {UserSessions, [], notify: fn(_, _) -> nil end}
    ]) do
      result = JoinChatRoom.on("a room", "a user id")

      assert result == {:error, "a room does not exists"}
      refute called UserSessions.notify(%{room: "a room", message: "welcome to the a room chat room, a user id!"}, to: "a user id")
    end
  end

  test "return an error message when already joined the chat room" do
    with_mocks([
      {ChatRooms, [], join: fn(_, _) -> {:error, :already_joined} end},
      {UserSessions, [], notify: fn(_, _) -> nil end}
    ]) do
      result = JoinChatRoom.on("a room", "a user id")

      assert result == {:error, "you already joined the a room room!"}
      refute called UserSessions.notify(%{room: "a room", message: "welcome to the a room chat room, a user id!"}, to: "a user id")
    end
  end

  test "notifies user sessions when joining a chat room" do
    with_mocks([
      {ChatRooms, [], join: fn(_, _) -> :ok end},
      {UserSessions, [], notify: fn(_, _) -> nil end}
    ]) do
      result = JoinChatRoom.on("a room", "a user id")

      assert result == :ok
      assert called UserSessions.notify(%{room: "a room", message: "welcome to the a room chat room, a user id!"}, to: "a user id")
    end
  end
end