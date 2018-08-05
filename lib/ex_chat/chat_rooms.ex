defmodule ExChat.ChatRooms do
  use Supervisor

  alias ExChat.{ChatRoom, ChatRoomRegistry}

  ##############
  # Client API #
  ##############

  def create(room) do
    case find(room) do
      {:ok, _pid} ->
        {:error, :already_exists}
      {:error, :unexisting_room} ->
        {:ok, _pid} = start(room)
        :ok
    end
  end

  def join(room, [as: session_id]) do
    case find(room) do
      {:ok, pid} ->
        try_join_chatroom(pid, session_id)
      {:error, :unexisting_room} ->
        {:error, :unexisting_room}
    end
  end

  def send(message, [to: room, as: session_id]) do
    case find(room) do
      {:ok, pid} -> ChatRoom.send(pid, message, as: session_id)
      error -> error
    end
  end

  defp try_join_chatroom(chatroom_pid, session_id) do
    case ChatRoom.join(chatroom_pid, session_id) do
      :ok ->
        :ok
      {:error, :already_joined} ->
        {:error, :already_joined}
    end
  end

  defp find(room) do
    case Registry.lookup(ChatRoomRegistry, room) do
      [] -> {:error, :unexisting_room}
      [{pid, nil}] -> {:ok, pid}
    end
  end

  ####################
  # Server Callbacks #
  ####################

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, [], name: :chatroom_supervisor)
  end

  def init(_) do
    children = [worker(ChatRoom, [])]
    supervise(children, strategy: :simple_one_for_one)
  end

  defp start(chatroom_name) do
    name = {:via, Registry, {ChatRoomRegistry, chatroom_name}}

    Supervisor.start_child(:chatroom_supervisor, [name])
  end
end
