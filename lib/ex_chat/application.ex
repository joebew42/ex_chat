defmodule ExChat.Application do
  use Supervisor

  @http_options [
    port: 4000,
    dispatch: ExChat.Web.Router.dispatch
  ]

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {Registry, keys: :unique, name: ExChat.ChatRoomRegistry},
      {Registry, keys: :unique, name: ExChat.UserSessionRegistry},
      ExChat.ChatRooms,
      ExChat.UserSessions,
      ExChat.AccessTokenRepository,
      ExChat.Setup,
      Plug.Adapters.Cowboy2.child_spec(scheme: :http, plug: ExChat.Web.Router, options: @http_options)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
