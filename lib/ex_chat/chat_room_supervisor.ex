defmodule ExChat.ChatRoomSupervisor do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, [], name: :chatroom_supervisor)
  end

  def init(_) do
    children = [worker(ExChat.ChatRoom, [])]
    supervise(children, strategy: :simple_one_for_one)
  end

  def create(name) do
    Supervisor.start_child(:chatroom_supervisor, [name])
  end
end
