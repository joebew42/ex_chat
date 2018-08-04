defmodule ExChat.UseCases.ValidateAccessTokenTest do
  use ExUnit.Case, async: true

  import Mock

  alias ExChat.AccessTokenRepository
  alias ExChat.UseCases.ValidateAccessToken

  test "return an error when there is no access token" do
    with_mock(AccessTokenRepository, find_user_session_by: fn(_) -> nil end) do
      assert ValidateAccessToken.on("an invalid token") == {:error, :access_token_not_valid}
      assert called AccessTokenRepository.find_user_session_by("an invalid token")
    end
  end

  test "return the user session when there is an access token" do
    with_mock(AccessTokenRepository, find_user_session_by: fn(_) -> "a user session" end) do
      assert ValidateAccessToken.on("a valid token") == {:ok, "a user session"}
      assert called AccessTokenRepository.find_user_session_by("a valid token")
    end
  end
end