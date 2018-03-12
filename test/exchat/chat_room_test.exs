defmodule ExChat.ChatRoomTest do
  use ExUnit.Case, async: true

  alias ExChat.ChatRoom

  setup do
    start_supervised ChatRoom
    %{}
  end

  test "not receive messages when not subscribed" do
    ChatRoom.send("hello world")

    refute_receive "hello world"
  end

  test "receive messages when subscribed" do
    ChatRoom.join(self())

    ChatRoom.send("hello world")

    assert_receive "hello world"
  end
end
