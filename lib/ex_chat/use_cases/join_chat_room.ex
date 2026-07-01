defmodule ExChat.UseCases.JoinChatRoom do

  alias ExChat.{ChatRooms, Greeting, UserSessions}

  def on(room, user_id, now \\ Time.utc_now()) do
    case ChatRooms.join(room, as: user_id) do
      :ok ->
        greeting = Greeting.greeting(now)
        UserSessions.notify(%{room: room, message: "#{greeting}, #{user_id}! Welcome to the #{room} chat room, #{user_id}!"}, to: user_id)
        :ok
      {:error, :already_joined} ->
        {:error, "you already joined the #{room} room!"}
      {:error, :unexisting_room} ->
        {:error, "#{room} does not exists"}
    end
  end
end