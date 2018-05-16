defmodule ExChat.ChatRoom do
  use GenServer

  defstruct subscribers: [], name: nil

  def create(name) do
    GenServer.start_link(__MODULE__, %__MODULE__{name: name}, name: via_registry(name))
  end

  def start_link(name), do: create(name)

  def init(state) do
    {:ok, state}
  end

  def find(room) do
    Registry.lookup(ExChat.Registry, room)
  end

  def join(pid, subscriber) do
    GenServer.call(pid, {:join, subscriber})
  end

  def send(pid, message) do
    :ok = GenServer.cast(pid, {:send, message})
  end

  def handle_call({:join, subscriber}, _from, state) do
    {message, new_state} = case Enum.member?(state.subscribers, subscriber) do
      true ->
        {{:error, :already_joined}, state}
      false ->
        {:ok, add_subscriber(state, subscriber)}
    end

    {:reply, message, new_state}
  end

  def handle_call({:joined?, client}, _from, state) do
    result = Enum.member?(state.subscribers, client)

    {:reply, result, state}
  end

  def handle_cast({:send, message}, state = %__MODULE__{name: name}) do
    Enum.each(state.subscribers, &Kernel.send(&1, {name, message}));
    {:noreply, state}
  end

  defp add_subscriber(state = %__MODULE__{subscribers: subscribers}, subscriber) do
    %__MODULE__{state | subscribers: [subscriber|subscribers]}
  end

  defp via_registry(name), do: {:via, Registry, {ExChat.Registry, name}}
end
