defmodule ExChat.AuthenticationService do
  use GenServer

  ##############
  # Client API #
  ##############

  def add(access_token, user_session) do
    :ok = GenServer.call(:authentication_service, {:add, access_token, user_session})
  end

  def find_user_session_by(access_token) do
    GenServer.call(:authentication_service, {:find_user_session_by, access_token})
  end

  ####################
  # Server Callbacks #
  ####################

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: :authentication_service)
  end

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call({:add, access_token, user_session}, _from, state) do
    {:reply, :ok, Map.put(state, access_token, user_session)}
  end

  def handle_call({:find_user_session_by, access_token}, _from, state) do
    {:reply, Map.get(state, access_token), state}
  end
end
