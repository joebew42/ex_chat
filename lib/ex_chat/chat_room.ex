defmodule ExChat.ChatRoom do
  use GenServer

  alias ExChat.UserSessions

  defstruct session_ids: [], name: nil

  def create(name = {:via, Registry, {_registry_name, chatroom_name}}) do
    GenServer.start_link(__MODULE__, %__MODULE__{name: chatroom_name}, name: name)
  end
  def create(chatroom_name) do
    GenServer.start_link(__MODULE__, %__MODULE__{name: chatroom_name}, name: String.to_atom(chatroom_name))
  end

  def start_link(name), do: create(name)

  def init(state) do
    {:ok, state}
  end

  def join(pid, session_id) do
    GenServer.call(pid, {:join, session_id})
  end

  def send(pid, message, [as: session_id]) do
    :ok = GenServer.call(pid, {:send, message, :as, session_id})
  end

  def handle_call({:join, session_id}, _from, state) do
    {message, new_state} = case joined?(state.session_ids, session_id) do
      true -> {{:error, :already_joined}, state}
      false -> {:ok, add_session_id(state, session_id)}
    end

    {:reply, message, new_state}
  end

  def handle_call({:send, message, :as, session_id}, _from, state = %__MODULE__{name: name}) do
    Enum.each(state.session_ids, &UserSessions.notify(%{from: session_id, room: name, message: message}, to: &1))
    {:reply, :ok, state}
  end

  defp joined?(session_ids, session_id), do: Enum.member?(session_ids, session_id)

  defp add_session_id(state = %__MODULE__{session_ids: session_ids}, session_id) do
    %__MODULE__{state | session_ids: [session_id|session_ids]}
  end
end
