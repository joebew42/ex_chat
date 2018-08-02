defmodule ExChat.Setup do
  use Task, restart: :transient

  alias ExChat.{ChatRooms, UserSessions, AuthenticationService}

  def start_link(_args) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    ChatRooms.create("default")
    UserSessions.create("default-user-session")
    AuthenticationService.add("A_DEFAULT_USER_ACCESS_TOKEN", "default-user-session")
  end
end
