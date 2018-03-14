defmodule ExChat.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_chat,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExChat, []}
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.0"},
      {:web_socket, "~> 0.1.0"},
      {:websockex, "~> 0.4.0", only: :test}
    ]
  end
end
