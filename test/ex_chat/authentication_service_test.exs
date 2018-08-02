defmodule ExChat.AuthenticationServiceTest do
  use ExUnit.Case, async: true

  alias ExChat.AuthenticationService

  setup do
    start_supervised! AuthenticationService
    :ok
  end

  test "return nil when there is no user session associated to the token" do
    assert AuthenticationService.find_user_session_by("a-token") == nil
  end

  test "return the user session associated to the token" do
    AuthenticationService.add("a-token", "a-user-session")

    assert AuthenticationService.find_user_session_by("a-token") == "a-user-session"
  end
end