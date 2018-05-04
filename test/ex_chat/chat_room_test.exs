defmodule ExChat.ChatRoomTest do
  use ExUnit.Case, async: true

  alias ExChat.ChatRoom

  setup do
    {:ok, pid} = start_supervised ChatRoom
    %{chatroom: pid}
  end

  test "not receive messages when not subscribed", %{chatroom: chatroom} do
    ChatRoom.send(chatroom, "hello world")

    refute_receive "hello world"
  end

  test "receive messages when subscribed", %{chatroom: chatroom} do
    ChatRoom.join(chatroom, self())

    ChatRoom.send(chatroom, "hello world")

    assert_receive "hello world"
  end
end
