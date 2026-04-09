defmodule ExChat.UseCases.CreateUserTest do
  use ExUnit.Case, async: true

  import Mock

  alias ExChat.{UserSessions, AccessTokenRepository}
  alias ExChat.UseCases.CreateUser

  test "return an error when the username is already taken" do
    with_mock(UserSessions, create: fn(_) -> {:error, :already_exists} end) do
      result = CreateUser.on("alice")

      assert result == {:error, "username already taken"}
      assert called UserSessions.create("alice")
    end
  end

  test "return the username and an access token when the user is created" do
    with_mocks([
      {UserSessions, [], create: fn(_) -> :ok end},
      {AccessTokenRepository, [], add: fn(_, _) -> :ok end}
    ]) do
      {:ok, result} = CreateUser.on("alice")

      assert result.username == "alice"
      assert is_binary(result.access_token)
      assert called UserSessions.create("alice")
      assert called AccessTokenRepository.add(result.access_token, "alice")
    end
  end
end
