defmodule ExChat.UserSessionsTest do
  use ExUnit.Case, async: true

  alias ExChat.UserSessions

  setup do
    start_supervised! UserSessions
    start_supervised! {Registry, keys: :unique, name: ExChat.UserSessionRegistry}
    :ok
  end

  describe "when create a UserSession" do
    test "an error is received when the session already exist" do
      UserSessions.create("a-session-id")

      result = UserSessions.create("a-session-id")

      assert result == {:error, :already_exists}
    end

    test "an ok is received" do
      result = UserSessions.create("a-session-id")

      assert result == :ok
    end
  end

  describe "when subscribe to a UserSession" do
    test "an error is received when the session does not exist" do
      result = UserSessions.subscribe(self(), to: "a-session-id")

      assert result == {:error, :session_not_exists}
    end

    test "an ok is received when the session exists" do
      UserSessions.create("a-session-id")

      result = UserSessions.subscribe(self(), to: "a-session-id")

      assert result == :ok
    end
  end

  describe "when send a message to a UserSession" do
    test "an error is received when the session does not exist" do
      result = UserSessions.notify("a message", to: "a-session-id")

      assert result == {:error, :session_not_exists}
    end

    test "a message is correctly delivered" do
      UserSessions.create("a-session-id")

      result = UserSessions.notify("a message", to: "a-session-id")

      assert result == :ok
    end
  end

  describe "when subscribed to a UserSession" do
    test "messages received are forwarded to subscribers" do
      UserSessions.create("a-session-id")
      UserSessions.subscribe(self(), to: "a-session-id")

      UserSessions.notify("a message", to: "a-session-id")

      assert_receive "a message"
    end
  end

  describe "when not subscribed to a UserSession" do
    test "messages received are not forwarded" do
      UserSessions.create("a-session-id")

      UserSessions.notify("a message", to: "a-session-id")

      refute_receive "a message"
    end
  end
end
