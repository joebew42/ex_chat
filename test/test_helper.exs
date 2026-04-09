ExUnit.start([trace: true, exclude: :ignore])

defmodule WebSocketClient do
  use WebSockex

  def connect_to(endpoint, forward_to: pid) do
    WebSockex.start_link(endpoint, __MODULE__, pid, [])
  end

  def send_as_text(client, message) do
    WebSockex.send_frame(client, {:text, message})
  end

  def handle_frame({:text, message}, test_process) do
    send test_process, message;
    {:ok, test_process}
  end
end

defmodule PingAwareWebSocketClient do
  use WebSockex

  def connect_to(endpoint, forward_to: pid) do
    WebSockex.start_link(endpoint, __MODULE__, pid, [])
  end

  def handle_frame({:text, message}, test_process) do
    send(test_process, message)
    {:ok, test_process}
  end

  def handle_ping(frame, test_process) do
    send(test_process, {:ping_received, frame})
    {:reply, :pong, test_process}
  end
end

defmodule NullProcess do
  def start, do: spawn(__MODULE__, :loop, [])

  def loop do
    receive do _ -> loop() end
  end
end
