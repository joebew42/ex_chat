defmodule ExChat.ChatRoom do
  use GenServer

  alias ExChat.ChatRoomRegistry

  defstruct clients: [], name: nil

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

  def join(pid, client) do
    GenServer.call(pid, {:join, client})
  end

  def send(pid, message) do
    :ok = GenServer.cast(pid, {:send, message})
  end

  def handle_call({:join, client}, _from, state) do
    {message, new_state} = case joined?(state.clients, client) do
      true -> {{:error, :already_joined}, state}
      false -> {:ok, add_client(state, client)}
    end

    {:reply, message, new_state}
  end

  def handle_cast({:send, message}, state = %__MODULE__{name: name}) do
    Enum.each(state.clients, &Kernel.send(&1, {name, message}));
    {:noreply, state}
  end

  defp joined?(clients, client), do: Enum.member?(clients, client)

  defp add_client(state = %__MODULE__{clients: clients}, client) do
    %__MODULE__{state | clients: [client|clients]}
  end

  defp via_registry(name), do: {:via, Registry, {ChatRoomRegistry, name}}
end
