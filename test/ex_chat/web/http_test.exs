defmodule ExChat.Web.HttpTest do
  use ExUnit.Case, async: true
  use WebSockex

  alias ExChat.Supervisor

  setup do
    start_supervised Supervisor
    %{}
  end

  test "receive back the message sent" do
    {:ok, client} = WebSockex.start_link("ws://localhost:4000/echo", __MODULE__, self(), [])
    WebSockex.send_frame(client, {:text, "hello world"})

    assert_receive "hello world", 1_000
  end

  def handle_frame({:text, message}, test_process) do
    send test_process, message;
    {:ok, test_process}
  end
end
