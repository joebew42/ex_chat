defmodule ExChat.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_chat,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExChat, []}
    ]
  end

  def aliases do
    [
      test: "test --no-start"
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 2.4"},
      {:plug, "~> 1.6"},
      {:poison, "~> 3.1"},
      {:websockex, "~> 0.4.0", only: :test},
      {:mock, "~> 0.3.3", only: :test}
    ]
  end
end
