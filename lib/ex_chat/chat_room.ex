defmodule ExChat.ChatRoom do
  use GenServer

  alias ExChat.ChatRoomRegistry

  defstruct session_ids: [], name: nil

  def create(name) do
    GenServer.start_link(__MODULE__, %__MODULE__{name: name}, name: via_registry(name))
  end

  def start_link(name), do: create(name)

  def init(state) do
    {:ok, state}
  end

  def find(room) do
    Registry.lookup(ChatRoomRegistry, room)
  end

  def join(pid, session_id) do
    GenServer.call(pid, {:join, session_id})
  end

  def send(pid, message) do
    :ok = GenServer.cast(pid, {:send, message})
  end

  def handle_call({:join, session_id}, _from, state) do
    {message, new_state} = case joined?(state.session_ids, session_id) do
      true -> {{:error, :already_joined}, state}
      false -> {:ok, add_session_id(state, session_id)}
    end

    {:reply, message, new_state}
  end

  def handle_cast({:send, message}, state = %__MODULE__{name: name}) do
    Enum.each(state.session_ids, &Kernel.send(&1, {name, message}));
    {:noreply, state}
  end

  defp joined?(session_ids, session_id), do: Enum.member?(session_ids, session_id)

  defp add_session_id(state = %__MODULE__{session_ids: session_ids}, session_id) do
    %__MODULE__{state | session_ids: [session_id|session_ids]}
  end

  defp via_registry(name), do: {:via, Registry, {ChatRoomRegistry, name}}
end
