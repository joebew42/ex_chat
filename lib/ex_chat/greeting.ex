defmodule ExChat.Greeting do
  def greeting(%Time{hour: hour}) when hour in 5..11, do: "Good morning"
  def greeting(%Time{hour: hour}) when hour in 12..16, do: "Good afternoon"
  def greeting(%Time{hour: hour}) when hour in 17..20, do: "Good evening"
  def greeting(%Time{hour: hour}) when hour in 21..23, do: "Good night"
  def greeting(%Time{hour: hour}) when hour in 0..4, do: "Good night"
end
