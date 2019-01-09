defmodule ExChat.Collaborator do
  @callback say_hello() :: String.t()
end