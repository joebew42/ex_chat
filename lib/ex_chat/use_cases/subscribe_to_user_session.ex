defmodule ExChat.UseCases.SubscribeToUserSession do

  alias ExChat.UserSessions

  def on(subscriber_pid, user_id) do
    UserSessions.subscribe(subscriber_pid, to: user_id)
  end
end