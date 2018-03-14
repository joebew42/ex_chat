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

    send_as_text "hello world", {:to, ws_client}

    assert_receive "hello world"
  end
end
