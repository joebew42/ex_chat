defmodule ExChat.UseCases.JoinChatRoom do

  alias ExChat.{ChatRooms, UserSessions, WelcomeMessage}

  def on(room, user_id) do
    case ChatRooms.join(room, as: user_id) do
      :ok ->
        UserSessions.notify(%{room: room, message: WelcomeMessage.for_user(room, user_id)}, to: user_id)
        :ok
      {:error, :already_joined} ->
        {:error, "you already joined the #{room} room!"}
      {:error, :unexisting_room} ->
        {:error, "#{room} does not exists"}
    end
  end
end