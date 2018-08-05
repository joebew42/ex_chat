defmodule ExChat.ChatRoomTest do
  use ExUnit.Case, async: false

  import Mock

  alias ExChat.UserSessions
  alias ExChat.ChatRoom

  test "notify subscribed user session when message is received" do
    {:ok, chatroom} = ChatRoom.create("room_name")
    ChatRoom.join(chatroom, "a-user-session-id")

    with_mock UserSessions, [notify: fn(_message, [to: _user_session_id]) -> :ok end] do
      expected_message = %{
        from: "another-user-session-id",
        room: "room_name",
        message: "a message"
      }

      ChatRoom.send(chatroom, "a message", as: "another-user-session-id")

      assert called UserSessions.notify(expected_message, to: "a-user-session-id")
    end
  end
end
