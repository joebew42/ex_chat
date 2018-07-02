defmodule ExChat.UserSessionsTest do
  use ExUnit.Case, async: true

  alias ExChat.UserSessions

  describe "when create a UserSession" do
    test "an error is received when the session already exist" do
      result = UserSessions.create("existing-user-session")

      assert result == {:error, :already_exists}
    end

    test "an ok is received" do
      result = UserSessions.create("unexisting-user-session")

      assert result == :ok
    end
  end

  describe "when subscribe to a UserSession" do
    test "an error is received when the session does not exist" do
      result = UserSessions.subscribe(self(), to: "unexisting-user-session")

      assert result == {:error, :session_not_exists}
    end

    test "an ok is received when the session exists" do
      result = UserSessions.subscribe(self(), to: "existing-user-session")

      assert result == :ok
    end
  end

  describe "when send a message to a UserSession" do
    test "an error is received when the session does not exist" do
      result = UserSessions.send("a message", to: "unexisting-user-session")

      assert result == {:error, :session_not_exists}
    end

    test "a message is correctly delivered" do
      result = UserSessions.send("a message", to: "existing-user-session")

      assert result == :ok
    end
  end

  describe "when subscribed to a UserSession" do
    test "messages received are forwarded to subscribers" do
      :ok = UserSessions.subscribe(self(), to: "existing-user-session")

      :ok = UserSessions.send("a message", to: "existing-user-session")

      assert_receive "a message"
    end
  end

  describe "when not subscribed to a UserSession" do
    test "messages received are not forwarded" do
      :ok = UserSessions.send("a message", to: "existing-user-session")

      refute_receive "a message"
    end
  end
end
