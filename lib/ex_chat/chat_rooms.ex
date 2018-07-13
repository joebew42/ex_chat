defmodule ExChat.ChatRooms do

  alias ExChat.ChatRoom
  alias ExChat.ChatRoomSupervisor
  alias ExChat.UserSessions

  def join(room, session_id) do
    case find_chatroom(room) do
      {:ok, pid} ->
        try_join_chatroom(room, session_id, pid)
      {:error, :unexisting_room} ->
        send_error_message(session_id, room <> " does not exists")
    end
  end

  def send(room, message) do
    case find_chatroom(room) do
      {:ok, pid} -> ChatRoom.send(pid, message)
      error -> error
    end
  end

  def create(room) do
    case find_chatroom(room) do
      {:ok, _pid} ->
        {:error, :already_exists}
      {:error, :unexisting_room} ->
        {:ok, _pid} = ChatRoomSupervisor.create(room)
        :ok
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

  defp find_chatroom(room) do
    case ChatRoom.find(room) do
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
end
