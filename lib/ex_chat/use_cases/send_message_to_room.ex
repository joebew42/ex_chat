defmodule ExChat.UseCases.SendMessageToRoom do

  alias ExChat.Rooms

  def on(message, room, user_id) do
    case Rooms.send(message, to: room, as: user_id) do
      :ok ->
        :ok
      {:error, :unexisting_room} ->
        {:error, "#{room} does not exists"}
    end
  end
end