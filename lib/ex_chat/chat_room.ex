defmodule ExChat.ChatRoom do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: :chatroom)
  end

  def init(subscribers) do
    {:ok, subscribers}
  end

  def join(pid) do
    :ok = GenServer.call(:chatroom, {:join, pid})
  end

  def send(message) do
    GenServer.cast(:chatroom, {:send, message})
  end

  # Callbacks

  def handle_call({:join, subscriber}, _from, subscribers) do
    {:reply, :ok, subscribers ++ [subscriber]}
  end

  def handle_cast({:send, message}, subscribers) do
    Enum.each(subscribers,
      fn(subscriber) ->
        Kernel.send(subscriber, message)
      end
    );

    {:noreply,  subscribers}
  end
end
