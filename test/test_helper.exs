ExUnit.start([trace: true])

defmodule WebSocketClient do
  use WebSockex

  def connect_to(ws_endpoint, {:forward_to, pid}) do
    WebSockex.start_link(ws_endpoint, __MODULE__, pid, [])
  end

  def send_as_text(message, {:using, ws_client}) do
    WebSockex.send_frame(ws_client, {:text, message})
  end

  def handle_frame({:text, message}, test_process) do
    send test_process, message;
    {:ok, test_process}
  end
end
