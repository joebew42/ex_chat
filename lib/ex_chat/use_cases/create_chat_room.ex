defmodule ExChat.UseCases.CreateChatRoom do

  alias ExChat.ChatRooms

  def on(room) do
    case ChatRooms.create(room) do
      :ok ->
        {:ok, "#{room} has been created!"}
      {:error, :already_exists} ->
        {:error, "#{room} already exists"}
    end
  end
end