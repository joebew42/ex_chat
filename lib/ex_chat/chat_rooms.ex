defmodule ExChat.ChatRooms do
  use GenServer

  alias ExChat.ChatRoom

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: :chatrooms)
  end

  def init(chatrooms) do
    {:ok, chatrooms}
  end

  def join(room, client) do
    :ok = GenServer.call(:chatrooms, {:join, client, :room, room})
  end

  def send(room, message) do
    :ok = GenServer.call(:chatrooms, {:send, message, :room, room})
  end

  def handle_call({:join, client, :room, room}, _from, chatrooms) do
    new_chatrooms = create_and_join_chatroom(chatrooms, room, client)
    {:reply, :ok, new_chatrooms}
  end

  def handle_call({:send, message, :room, room}, _from, chatrooms) do
    pid = find_chatroom(chatrooms, room)
    ExChat.ChatRoom.send(pid, message)
    {:reply, :ok, chatrooms}
  end

  defp create_and_join_chatroom(chatrooms, room, client) do
    new_chatrooms = create_chatroom(chatrooms, room)
    join_chatroom(new_chatrooms, room, client)
    new_chatrooms
  end

  defp join_chatroom(chatrooms, room, client) do
    case find_chatroom(chatrooms, room) do
      nil -> nil
      pid -> ExChat.ChatRoom.join(pid, client)
    end
  end

  defp create_chatroom(chatrooms, room) do
    case find_chatroom(chatrooms, room) do
      nil ->
        {:ok, pid} = ChatRoom.create(room)
        Map.put(chatrooms, room, pid)
      _ ->
        chatrooms
    end
  end

  defp find_chatroom(chatrooms, name), do: Map.get(chatrooms, name)
end
