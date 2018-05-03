defmodule ExChat.ChatRooms do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: :chatrooms)
  end

  def init(chatrooms) do
    {:ok, chatrooms}
  end

  def join(room, client) do
    :ok = GenServer.call(:chatrooms, {:join, client, :room, room})
  end

  def send(_room, message) do
    :ok = GenServer.call(:chatrooms, {:send, message})
  end

  def handle_call({:join, client, :room, _room}, _from, chatrooms) do
    ExChat.ChatRoom.join(client)
    {:reply, :ok, chatrooms}
  end

  def handle_call({:send, message}, _from, chatrooms) do
    ExChat.ChatRoom.send(message)
    {:reply, :ok, chatrooms}
  end
end
