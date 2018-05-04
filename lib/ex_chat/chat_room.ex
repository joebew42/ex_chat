defmodule ExChat.ChatRoom do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(subscribers) do
    {:ok, subscribers}
  end

  def join(pid, subscriber) do
    :ok = GenServer.call(pid, {:join, subscriber})
  end

  def send(pid, message) do
    GenServer.cast(pid, {:send, message})
  end

  def handle_call({:join, subscriber}, _from, subscribers) do
    {:reply, :ok, [subscriber|subscribers]}
  end

  def handle_cast({:send, message}, subscribers) do
    Enum.each(subscribers, &Kernel.send(&1, message));
    {:noreply,  subscribers}
  end
end
