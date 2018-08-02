defmodule ExChat.AccessTokenRepositoryTest do
  use ExUnit.Case, async: true

  alias ExChat.AccessTokenRepository

  setup do
    start_supervised! AccessTokenRepository
    :ok
  end

  test "return nil when there is no user session associated to the token" do
    assert AccessTokenRepository.find_user_session_by("a-token") == nil
  end

  test "return the user session associated to the token" do
    AccessTokenRepository.add("a-token", "a-user-session")

    assert AccessTokenRepository.find_user_session_by("a-token") == "a-user-session"
  end
end