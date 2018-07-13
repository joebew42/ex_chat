defmodule ExChat.ChatRoomTest do
  use ExUnit.Case, async: true

  import Mock

  alias ExChat.{ChatRoomRegistry, UserSessions}
  alias ExChat.ChatRoom

  setup_all do
    start_supervised! {Registry, keys: :unique, name: ChatRoomRegistry}
    :ok
  end

  test "notify subscribed user session when a chatroom receives message" do
    {:ok, chatroom} = ChatRoom.create("room_name")
    ChatRoom.join(chatroom, "a-user-session-id")

    with_mock UserSessions, [send: fn(_message, [to: _user_session_id]) -> :ok end] do
      ChatRoom.send(chatroom, "a message")

      assert called UserSessions.send({"room_name", "a message"}, to: "a-user-session-id")
    end
  end
end
