defmodule ExChat.ChatRooms do
  use Supervisor

  alias ExChat.{ChatRoom, ChatRoomRegistry, UserSessions}

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
        try_join_chatroom(room, session_id, pid)
      {:error, :unexisting_room} ->
        send_error_message(session_id, room <> " does not exists")
    end
  end

  def send(message, [to: room, as: session_id]) do
    case find(room) do
      {:ok, pid} -> ChatRoom.send(pid, message, as: session_id)
      error -> error
    end
  end

  defp try_join_chatroom(room, session_id, chatroom_pid) do
    case ChatRoom.join(chatroom_pid, session_id) do
      :ok ->
        send_welcome_message(session_id, room)
      {:error, :already_joined} ->
        send_error_message(session_id, "you already joined the " <> room <> " room!")
    end
  end

  defp find(room) do
    case Registry.lookup(ChatRoomRegistry, room) do
      [] -> {:error, :unexisting_room}
      [{pid, nil}] -> {:ok, pid}
    end
  end

  defp send_welcome_message(session_id, room) do
    UserSessions.notify({room, "welcome to the " <> room <> " chat room!"}, to: session_id)
  end

  defp send_error_message(session_id, message) do
    UserSessions.notify({:error, message}, to: session_id)
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
