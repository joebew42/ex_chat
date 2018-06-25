ExUnit.start([trace: true, exclude: :ignore])

defmodule WebSocketClient do
  use WebSockex

  def connect_to(ws_endpoint, forward_to: pid) do
    WebSockex.start_link(ws_endpoint, __MODULE__, pid, [])
  end

  def send_as_text(ws_client, message) do
    WebSockex.send_frame(ws_client, {:text, message})
  end

  def handle_frame({:text, message}, test_process) do
    send test_process, message;
    {:ok, test_process}
  end
end

defmodule NullProcess do
  def start, do: spawn(__MODULE__, :loop, [])

  def loop do
    receive do _ -> loop() end
  end
end
