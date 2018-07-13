defmodule ExChat.Init do
  use Task, restart: :transient

  alias ExChat.{ChatRooms, UserSessions}

  def start_link(_args) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    ChatRooms.create("default")
    UserSessions.create("default-user-session")
  end
end
