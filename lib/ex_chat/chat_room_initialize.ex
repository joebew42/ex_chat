defmodule ExChat.ChatRoomInitialize do
  use Task, restart: :transient

  alias ExChat.ChatRooms

  def start_link(_args) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    ChatRooms.create("default")
  end
end
