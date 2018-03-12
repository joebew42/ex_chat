defmodule ExChat.Supervisor do
  use Supervisor

  @http_options [
    port: 4000,
    dispatch: ExChat.Web.Http.dispatch_table
  ]

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      ExChat.ChatRoom,
      Plug.Adapters.Cowboy.child_spec(:http, ExChat.Web.Http, [], @http_options)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
