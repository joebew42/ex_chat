defmodule ExChat.UseCases.WhoAmI do

  def on(session_id) do
    {:ok, "You are logged in as #{session_id}"}
  end
end
