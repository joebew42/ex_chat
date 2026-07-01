defmodule ExChat.UseCases.CreateChatRoom do

  alias ExChat.Rooms

  def on(room) do
    case Rooms.create(room) do
      :ok ->
        {:ok, "#{room} has been created!"}
      {:error, :already_exists} ->
        {:error, "#{room} already exists"}
    end
  end
end