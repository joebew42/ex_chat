defmodule ExChat.ChatRoom do
  use GenServer

  defstruct subscribers: [], name: nil

  def start_link([name: name]) do
    GenServer.start_link(__MODULE__, %__MODULE__{name: name})
  end

  def init(state) do
    {:ok, state}
  end

  def join(pid, subscriber) do
    :ok = GenServer.call(pid, {:join, subscriber})
  end

  def send(pid, message) do
    GenServer.cast(pid, {:send, message})
  end

  def handle_call({:join, subscriber}, _from, state) do
    new_state = add_subscriber(state, subscriber)

    {:reply, :ok, new_state}
  end

  def handle_cast({:send, message}, state = %__MODULE__{name: name}) do
    Enum.each(state.subscribers, &Kernel.send(&1, {name, message}));
    {:noreply, state}
  end

  defp add_subscriber(state = %__MODULE__{subscribers: subscribers}, subscriber) do
    %__MODULE__{state | subscribers: [subscriber|subscribers]}
  end
end
