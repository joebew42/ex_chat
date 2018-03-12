defmodule ExChatTest do
  use ExUnit.Case
  doctest ExChat

  test "greets the world" do
    assert ExChat.hello() == :world
  end
end
