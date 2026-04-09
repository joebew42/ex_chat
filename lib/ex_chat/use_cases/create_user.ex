defmodule ExChat.UseCases.CreateUser do

  alias ExChat.{UserSessions, AccessTokenRepository}

  def on(username) do
    case UserSessions.create(username) do
      :ok ->
        access_token = generate_access_token()
        AccessTokenRepository.add(access_token, username)
        {:ok, %{username: username, access_token: access_token}}
      {:error, :already_exists} ->
        {:error, "username already taken"}
    end
  end

  defp generate_access_token do
    :crypto.strong_rand_bytes(16) |> Base.url_encode64()
  end
end
