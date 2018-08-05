defmodule ExChat.UseCases.SubscribeToUserSessionTest do
  use ExUnit.Case, async: true

  import Mock

  alias ExChat.UserSessions
  alias ExChat.UseCases.SubscribeToUserSession

  test "subscribe a process to a user session" do
    with_mock(UserSessions, subscribe: fn(_, _) -> nil end) do
      SubscribeToUserSession.on("a subscriber pid", "a user id")

      assert called UserSessions.subscribe("a subscriber pid", to: "a user id")
    end
  end
end