defmodule ExChat.Web.EchoWebSocketHandler do

  @behaviour :cowboy_websocket_handler

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_type, req, _opts) do
    state = nil
    {:ok, req, state}
  end

  def websocket_handle({:text, message}, req, state) do
    {:reply, {:text, message}, req, state}
  end

  def websocket_handle(_message, req, state) do
    {:ok, req, state}
  end

  def websocket_info(_info, req, state) do
    {:ok, req, state}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end
end
