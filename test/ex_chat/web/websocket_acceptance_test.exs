defmodule ExChat.Web.WebSocketAcceptanceTest do
  use ExUnit.Case, async: true
  import WebSocketClient

  setup_all do
    [:cowlib, :cowboy, :ranch]
    |> Enum.each(&(Application.start(&1)))
  end

  setup do
    start_supervised! ExChat.Application
    :ok
  end

  describe "As a Client when I provide an invalid token" do
    test "I get a 400 Bad Request" do
      result = connect_to websocket_chat_url(with: "AN_INVALID_ACCESS_TOKEN"), forward_to: self()

      assert result == {:error, %WebSockex.RequestError{code: 400, message: "Bad Request"}}
    end
  end

  describe "As a Client when I don't provide a token" do
    test "I get a 400 Bad Request" do
      result = connect_to websocket_chat_url(), forward_to: self()

      assert result == {:error, %WebSockex.RequestError{code: 400, message: "Bad Request"}}
    end
  end

  describe "As a User when I join the default chat room" do
    setup :connect_as_a_user

    test "I want to receive a welcome message containing my name", %{client: client} do
      send_as_text(client, "{\"command\":\"join\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, a-user!\"}"
    end

    test "I want that each connected clients receives the welcome message", %{client: client} do
      connect_to websocket_chat_url(with: "A_USER_ACCESS_TOKEN"), forward_to: self()

      send_as_text(client, "{\"command\":\"join\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, a-user!\"}"
      assert_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, a-user!\"}"
    end
  end

  describe "As a User when I send a message" do
    setup :connect_as_a_user

    test "I receive it back", %{client: client} do
      send_as_text(client, "{\"command\":\"join\"}")

      send_as_text(client, "{\"room\":\"default\",\"message\":\"Hello folks!\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"Hello folks!\",\"from\":\"a-user\"}"
    end

    test "I receive an error message if the room does not exist", %{client: client} do
      send_as_text(client, "{\"room\":\"unexisting_room\",\"message\":\"a message\"}")

      assert_receive "{\"error\":\"unexisting_room does not exists\"}"
    end
  end

  describe "As a User when I receive a message" do
    setup :connect_as_a_user

    test "I can read the name of the user who sent the message", %{client: client} do
      send_as_text(client, "{\"command\":\"join\"}")

      {:ok, other_client} = connect_to websocket_chat_url(with: "bar_token"), forward_to: NullProcess.start
      send_as_text(other_client, "{\"command\":\"join\"}")
      send_as_text(other_client, "{\"room\":\"default\",\"message\":\"Hello from other user!\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"Hello from other user!\",\"from\":\"bar_user\"}"
    end
  end

  describe "As a User when I create a new chat room" do
    setup :connect_as_a_user

    test "I receive an error message if the room already exist", %{client: client} do
      send_as_text(client, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(client, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")

      assert_receive "{\"error\":\"a_chat_room already exists\"}"
    end

    test "I receive a successful message", %{client: client} do
      send_as_text(client, "{\"command\":\"create\",\"room\":\"another_room\"}")

      assert_receive "{\"success\":\"another_room has been created!\"}"
    end
  end

  describe "As a User when I join a new chat room" do
    setup :connect_as_a_user

    test "I want to receive a welcome message that contain my name and the chat room name", %{client: client} do
      send_as_text(client, "{\"command\":\"create\",\"room\":\"a_chat_room\"}")
      send_as_text(client, "{\"command\":\"join\",\"room\":\"a_chat_room\"}")

      assert_receive "{\"room\":\"a_chat_room\",\"message\":\"welcome to the a_chat_room chat room, a-user!\"}"
    end
  end

  describe "As a User I cannot" do
    setup :connect_as_a_user

    test "join twice the same chat room", %{client: client} do
      send_as_text(client, "{\"command\":\"join\"}")
      send_as_text(client, "{\"command\":\"join\"}")

      assert_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, a-user!\"}"
      refute_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room, a-user!\"}"
      assert_receive "{\"error\":\"you already joined the default room!\"}"
    end

    test "send invalid messages", %{client: client} do
      send_as_text(client, "this is an invalid message")

      refute_receive _
    end

    test "send invalid commands", %{client: client} do
      send_as_text(client, "{\"something\":\"invalid\"}")

      refute_receive _
    end
  end

  defp connect_as_a_user(_context) do
    a_user = "a-user"
    an_access_token = "A_USER_ACCESS_TOKEN"

    ExChat.UserSessions.create(a_user)
    ExChat.AccessTokenRepository.add(an_access_token, a_user)

    {:ok, client} = connect_to websocket_chat_url(with: an_access_token), forward_to: self()
    {:ok, client: client}
  end

  defp websocket_chat_url() do
    "ws://localhost:4000/chat"
  end

  defp websocket_chat_url([with: access_token]) do
    "#{websocket_chat_url()}?access_token=#{access_token}"
  end
end
