defmodule ExChat.ChatRoom do
  use GenServer

  alias ExChat.UserSessions

  defstruct user_ids: [], name: nil

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

  def join(pid, user_id) do
    GenServer.call(pid, {:join, user_id})
  end

  def send(pid, message, [as: user_id]) do
    :ok = GenServer.call(pid, {:send, message, :as, user_id})
  end

  def handle_call({:join, user_id}, _from, state) do
    {message, new_state} = case joined?(state.user_ids, user_id) do
      true -> {{:error, :already_joined}, state}
      false -> {:ok, add_user_id(state, user_id)}
    end

    {:reply, message, new_state}
  end

  def handle_call({:send, message, :as, user_id}, _from, state = %__MODULE__{name: name}) do
    Enum.each(state.user_ids, &UserSessions.notify(%{from: user_id, room: name, message: message}, to: &1))
    {:reply, :ok, state}
  end

  defp joined?(user_ids, user_id), do: Enum.member?(user_ids, user_id)

  defp add_user_id(state = %__MODULE__{user_ids: user_ids}, user_id) do
    %__MODULE__{state | user_ids: [user_id|user_ids]}
  end
end
