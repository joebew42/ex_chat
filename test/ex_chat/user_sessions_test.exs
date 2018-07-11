defmodule ExChat.UserSessionsTest do
  use ExUnit.Case, async: true

  alias ExChat.UserSessionSupervisor

  alias ExChat.UserSessions

  setup do
    start_supervised! UserSessionSupervisor
    start_supervised! {Registry, keys: :unique, name: ExChat.UserSessionRegistry}
    :ok
  end

  describe "when create a UserSession" do
    test "an error is received when the session already exist" do
      UserSessions.create("a-user-session")

      result = UserSessions.create("a-user-session")

      assert result == {:error, :already_exists}
    end

    test "an ok is received" do
      result = UserSessions.create("a-user-session")

      assert result == :ok
    end
  end

  describe "when subscribe to a UserSession" do
    test "an error is received when the session does not exist" do
      result = UserSessions.subscribe(self(), to: "a-user-session")

      assert result == {:error, :session_not_exists}
    end

    test "an ok is received when the session exists" do
      UserSessions.create("a-user-session")

      result = UserSessions.subscribe(self(), to: "a-user-session")

      assert result == :ok
    end
  end

  describe "when send a message to a UserSession" do
    test "an error is received when the session does not exist" do
      result = UserSessions.send("a message", to: "a-user-session")

      assert result == {:error, :session_not_exists}
    end

    test "a message is correctly delivered" do
      UserSessions.create("a-user-session")
      result = UserSessions.send("a message", to: "a-user-session")

      assert result == :ok
    end
  end

  describe "when subscribed to a UserSession" do
    test "messages received are forwarded to subscribers" do
      UserSessions.create("a-user-session")
      UserSessions.subscribe(self(), to: "a-user-session")

      UserSessions.send("a message", to: "a-user-session")

      assert_receive "a message"
    end
  end

  describe "when not subscribed to a UserSession" do
    test "messages received are not forwarded" do
      UserSessions.create("a-user-session")

      UserSessions.send("a message", to: "a-user-session")

      refute_receive "a message"
    end
  end
end
