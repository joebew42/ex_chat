defmodule ExChat.UserSessionSupervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, [], name: :user_session_supervisor)
  end

  def init(_) do
    children = [worker(ExChat.UserSession, [])]
    supervise(children, strategy: :simple_one_for_one)
  end

  def create(user_session_id) do
    Supervisor.start_child(:user_session_supervisor, [user_session_id])
  end
end
