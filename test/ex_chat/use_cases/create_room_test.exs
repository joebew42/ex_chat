defmodule ExChat.UseCases.CreateRoomTest do
  use ExUnit.Case, async: true

  import Mock

  alias ExChat.Rooms
  alias ExChat.UseCases.CreateRoom

  test "return an error message when the room already exists" do
    with_mock(Rooms, create: fn(_) -> {:error, :already_exists} end) do
      result = CreateRoom.on("a room")

      assert result == {:error, "a room already exists"}
      assert called Rooms.create("a room")
    end
  end

  test "return an successful message when create a room" do
    with_mock(Rooms, create: fn(_) -> :ok end) do
      result = CreateRoom.on("a room")

      assert result == {:ok, "a room has been created!"}
      assert called Rooms.create("a room")
    end
  end
end