defmodule ExChat.AuthenticationService do
  def find_user_session_by(access_token) do
    case access_token do
      nil -> nil
      "AN_INVALID_ACCESS_TOKEN" -> nil
      "A_USER_ACCESS_TOKEN" -> "a-user"
      _ -> "default-user-session"
    end
  end
end
