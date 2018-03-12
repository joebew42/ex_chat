defmodule ExChat do
  use Application

  def start(_type, _args) do
    ExChat.Supervisor.start_link([])
  end
end
