defmodule ExChat.UseCases.ValidateAccessToken do

  alias ExChat.AccessTokenRepository

  def on(access_token) do
    case AccessTokenRepository.find_user_session_by(access_token) do
      nil ->
        {:error, :access_token_not_valid}
      user_session ->
        {:ok, user_session}
    end
  end
end