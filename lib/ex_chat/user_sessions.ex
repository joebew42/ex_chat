defmodule ExChat.UserSessions do
  use DynamicSupervisor

  alias ExChat.{UserSession, UserSessionRegistry}

  ##############
  # Client API #
  ##############

  def create(session_id) do
    case find(session_id) do
      nil ->
        start(session_id)
        :ok
      _pid ->
        {:error, :already_exists}
    end
  end

  def subscribe(client_pid, [to: session_id]) do
    case find(session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.subscribe(pid, client_pid)
    end
  end

  def notify(message, [to: session_id]) do
    case find(session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.notify(pid, message)
    end
  end

  ####################
  # Server Callbacks #
  ####################

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp start(session_id) do
    name = {:via, Registry, {UserSessionRegistry, session_id}}

    DynamicSupervisor.start_child(__MODULE__, {UserSession ,name})
  end

  defp find(session_id) do
    case Registry.lookup(UserSessionRegistry, session_id) do
       [] -> nil
       [{pid, nil}] -> pid
    end
  end
end
