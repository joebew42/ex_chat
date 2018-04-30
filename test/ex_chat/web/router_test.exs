defmodule ExChat.Web.RouterTest do
  use ExUnit.Case, async: true
  import WebSocketClient

  alias ExChat.Supervisor

  setup do
    start_supervised Supervisor
    %{}
  end

  describe "when join a chat room" do
    setup do
      {:ok, ws_client} = connect_to "ws://localhost:4000/room", forward_to: self()
      send_as_text(ws_client, "join")

      {:ok, ws_client: ws_client}
    end

    test "a welcome message is received" do
      assert_receive "{\"room\":\"default\",\"message\":\"welcome to the default chat room!\"}"
    end

    test "each message sent is received back", %{ws_client: ws_client} do
      send_as_text(ws_client, "Hello folks!")

      assert_receive "Hello folks!"
    end

    test "we receive all the messages sent by other clients" do
      {:ok, another_client} = connect_to "ws://localhost:4000/room", forward_to: NullProcess.start
      send_as_text(another_client, "join")

      send_as_text(another_client, "Hello from Twitch!")

      assert_receive "Hello from Twitch!"
    end
  end

end
