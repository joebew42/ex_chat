defmodule ExChat.ChatRooms do
  use GenServer

  alias ExChat.ChatRoom

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: :chatrooms)
  end

  def init(chatrooms) do
    Kernel.send self(), :create_default_chatroom
    {:ok, chatrooms}
  end

  def join(room, client) do
    :ok = GenServer.call(:chatrooms, {:join, client, :room, room})
  end

  def send(_room, message) do
    :ok = GenServer.call(:chatrooms, {:send, message})
  end

  def handle_call({:join, client, :room, _room}, _from, chatrooms) do
    pid = Map.get(chatrooms, "default")
    ExChat.ChatRoom.join(pid, client)
    {:reply, :ok, chatrooms}
  end

  def handle_call({:send, message}, _from, chatrooms) do
    pid = Map.get(chatrooms, "default")
    ExChat.ChatRoom.send(pid, message)
    {:reply, :ok, chatrooms}
  end

  def handle_info(:create_default_chatroom, chatrooms) do
    {:ok, pid} = ChatRoom.start_link([])
    new_chatrooms = Map.put(chatrooms, "default", pid)
    {:noreply, new_chatrooms}
  end
end
