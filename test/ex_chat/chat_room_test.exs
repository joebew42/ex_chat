defmodule ExChat.ChatRoomTest do
  use ExUnit.Case, async: true

  alias ExChat.ChatRoom

  setup do
    {:ok, pid} = ChatRoom.start_link(name: "room_name")
    %{chatroom: pid}
  end

  test "not receive messages when not subscribed", %{chatroom: chatroom} do
    ChatRoom.send(chatroom, "hello world")

    refute_receive {"room_name", "hello world"}
  end

  test "receive messages when subscribed", %{chatroom: chatroom} do
    ChatRoom.join(chatroom, self())

    ChatRoom.send(chatroom, "hello world")

    assert_receive {"room_name", "hello world"}
  end
end
