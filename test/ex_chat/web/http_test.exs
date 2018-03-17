defmodule ExChat.Web.HttpTest do
  use ExUnit.Case, async: true
  import WebSocketClient

  alias ExChat.Supervisor

  setup do
    start_supervised Supervisor
    %{}
  end

  test "receive back the message sent" do
    {:ok, ws_client} = connect_to "ws://localhost:4000/echo", {:forward_to, self()}

    send_as_text "hello world", {:using, ws_client}

    assert_receive "hello world"
  end

  describe "when join a chat room" do
    setup do
      {:ok, ws_client} = connect_to "ws://localhost:4000/room", {:forward_to, self()}
      send_as_text "join", {:using, ws_client}

      {:ok, ws_client: ws_client}
    end

    test "a welcome message is received" do
      assert_receive "welcome to the awesome chat room!"
    end

    test "each message sent is received back", %{ws_client: ws_client} do
      send_as_text "Hello folks!", {:using, ws_client}

      assert_receive "welcome to the awesome chat room!"
      assert_receive "Hello folks!"
    end
  end

end
