defmodule ExChat.UserSessions do
  alias ExChat.UserSession
  alias ExChat.UserSessionSupervisor

  def create(user_session_id) do
    case UserSession.exists?(user_session_id) do
      true -> {:error, :already_exists}
      false ->
          UserSessionSupervisor.create(user_session_id)
          :ok
    end
  end

  def subscribe(client_pid, to: user_session_id) do
    case UserSession.find(user_session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.subscribe(pid, client_pid)
    end
  end

  def send(message, to: user_session_id) do
    case UserSession.find(user_session_id) do
      nil -> {:error, :session_not_exists}
      pid -> UserSession.send(pid, message)
    end
  end
end
