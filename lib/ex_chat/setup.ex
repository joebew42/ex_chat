defmodule ExChat.Setup do
  use Task, restart: :transient

  alias ExChat.Rooms

  def start_link(_args) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    Rooms.create("default")
  end
end
