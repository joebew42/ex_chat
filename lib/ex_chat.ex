defmodule ExChat do
  use Application

  def start(_type, _args) do
    ExChat.Application.start_link([])
  end
end
