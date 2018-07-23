defmodule ExChat.Web.WebSocketAcceptanceTest do
  use ExUnit.Case, async: true
  import WebSocketClient

  setup_all do
    Application.start :ranch
  end

  setup do
    start_supervised! ExChat.Application
    :ok
  end

  describe "As a User when I join the default chat room" do
    setup :connect_as_a_user

    test "I want to receive a welcome message containing my name", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"command\":\"join\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, a-user!\"}"
    end
  end

  describe "As a User when I send a message" do
    setup :connect_as_a_user

    test "I receive it back", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"command\":\"join\"}")

      send_as_text(ws_client, "{\"room\":\"default\",\"message\":\"Hello folks!\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"Hello folks!\",\"from\":\"a-user\"}"
    end

    test "I receive an error message if the room does not exist", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"room\":\"unexisting_room\",\"message\":\"a message\"}")

      assert_receive "{\"error\":\"unexisting_room does not exists\"}"
    end
  end

  describe "As a User when I receive a message" do
    setup :connect_as_a_user

    test "I can read the name of the user who sent the message", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"command\":\"join\"}")

      {:ok, other_client} = connect_to "ws://localhost:4000/chat?access_token=A_DEFAULT_USER_ACCESS_TOKEN", forward_to: NullProcess.start
      send_as_text(other_client, "{\"command\":\"join\"}")
      send_as_text(other_client, "{\"room\":\"default\",\"message\":\"Hello from other user!\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"Hello from other user!\",\"from\":\"default-user-session\"}"
    end
  end

  describe "As a User when I create a new chat room" do
    setup :connect_as_a_user

    test "I receive an error message if the room already exist", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(ws_client, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")

      assert_receive "{\"error\":\"a_chat_room already exists\"}"
    end

    test "I receive a successful message", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"command\":\"create\",\"room\":\"another_room\"}")

      assert_receive "{\"success\":\"another_room has been created!\"}"
    end
  end

  describe "As a User when I join a new chat room" do
    setup :connect_as_a_user

    test "I want to receive a welcome message that contain my name and the chat room name", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(ws_client, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")

      assert_receive "{\"room\":\"a_chat_room\",\"message\":\"welcome to the a_chat_room chat room, a-user!\"}"
    end
  end

  describe "As a User I cannot" do
    setup :connect_as_a_user

    test "join twice the same chat room", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"command\":\"join\"}")
      send_as_text(ws_client, "{\"command\":\"join\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, a-user!\"}"
      refute_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, a-user!\"}"
      assert_receive "{\"error\":\"you already joined the default room!\"}"
    end

    test "send invalid messages", %{ws_client: ws_client} do
      send_as_text(ws_client, "this is an invalid message")

      refute_receive _
    end

    test "send invalid commands", %{ws_client: ws_client} do
      send_as_text(ws_client, "{\"something\":\"invalid\"}")

      refute_receive _
    end
  end

  defp connect_as_a_user(_context) do
    ExChat.UserSessions.create("a-user")
    {:ok, ws_client} = connect_to "ws://localhost:4000/chat?access_token=A_USER_ACCESS_TOKEN", forward_to: self()
    {:ok, ws_client: ws_client}
  end
end
