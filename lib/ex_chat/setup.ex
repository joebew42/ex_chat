defmodule ExChat.Setup do
  use Task, restart: :transient

  alias ExChat.{ChatRooms, UserSessions, AccessTokenRepository}

  def start_link(_args) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    ChatRooms.create("default")

    UserSessions.create("foo_user")
    UserSessions.create("bar_user")

    AccessTokenRepository.add("foo_token", "foo_user")
    AccessTokenRepository.add("bar_token", "bar_user")
  end
end
