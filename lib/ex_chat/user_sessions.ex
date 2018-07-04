defmodule ExChat.UserSessions do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, nil, name: :user_sessions)
  end

  def init(state) do
    {:ok, state}
  end

  def create("existing-user-session") do
    {:error, :already_exists}
  end
  def create("unexisting-user-session") do
    :ok
  end

  def subscribe(client_pid, to: "existing-user-session") do
    GenServer.call(:user_sessions, {:subscribe, client_pid})
  end
  def subscribe(_client_pid, _username) do
    {:error, :session_not_exists}
  end

  def send(message, to: "existing-user-session") do
    GenServer.call(:user_sessions, {:send, message})
  end
  def send(_message, to: _username) do
    {:error, :session_not_exists}
  end

  def handle_call({:subscribe, client_pid}, _from, _state) do
    {:reply, :ok, client_pid}
  end

  def handle_call({:send, _message}, _from, nil) do
    {:reply, :ok, nil}
  end
  def handle_call({:send, message}, _from, client_pid) do
    Kernel.send(client_pid, message)

    {:reply, :ok, client_pid}
  end
end
