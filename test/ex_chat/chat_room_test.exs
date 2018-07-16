defmodule ExChat.ChatRoomTest do
  use ExUnit.Case, async: true

  import Mock

  alias ExChat.UserSessions
  alias ExChat.ChatRoom

  test "notify subscribed user session when message is received" do
    {:ok, chatroom} = ChatRoom.create("room_name")
    ChatRoom.join(chatroom, "a-user-session-id")

    with_mock UserSessions, [notify: fn(_message, [to: _user_session_id]) -> :ok end] do
      ChatRoom.send(chatroom, "a message")

      assert called UserSessions.notify({"room_name", "a message"}, to: "a-user-session-id")
    end
  end
end
