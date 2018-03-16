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

  test "when join a chat room a welcome message is received" do
    {:ok, ws_client} = connect_to "ws://localhost:4000/room", {:forward_to, self()}

    send_as_text "join", {:using, ws_client}

    assert_receive "welcome to the awesome chat room!"
  end

  test "when join a chat room I am able to send messages" do
    {:ok, ws_client} = connect_to "ws://localhost:4000/room", {:forward_to, self()}
    send_as_text "join", {:using, ws_client}

    send_as_text "Hello there!", {:using, ws_client}

    assert_receive "welcome to the awesome chat room!"
    assert_receive "Hello there!"
  end
end
