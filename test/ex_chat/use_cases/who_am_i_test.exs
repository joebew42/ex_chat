defmodule ExChat.UseCases.WhoAmITest do
  use ExUnit.Case, async: true

  alias ExChat.UseCases.WhoAmI

  test "return a message telling the user how they are logged in" do
    assert WhoAmI.on("a-user") == {:ok, "You are logged in as a-user"}
  end
end
