defmodule ExChat.GreetingTest do
  use ExUnit.Case, async: true

  alias ExChat.Greeting

  test "greets with good morning in the morning" do
    assert Greeting.greeting(~T[08:00:00]) == "Good morning"
  end

  test "greets with good afternoon in the afternoon" do
    assert Greeting.greeting(~T[14:00:00]) == "Good afternoon"
  end

  test "greets with good evening in the evening" do
    assert Greeting.greeting(~T[18:00:00]) == "Good evening"
  end

  test "greets with good night late at night" do
    assert Greeting.greeting(~T[23:00:00]) == "Good night"
  end

  test "greets with good night in the small hours" do
    assert Greeting.greeting(~T[02:00:00]) == "Good night"
  end

  describe "bucket boundaries" do
    test "morning starts at 05:00 and ends at 11:59" do
      assert Greeting.greeting(~T[05:00:00]) == "Good morning"
      assert Greeting.greeting(~T[11:59:59]) == "Good morning"
    end

    test "afternoon starts at 12:00 and ends at 16:59" do
      assert Greeting.greeting(~T[12:00:00]) == "Good afternoon"
      assert Greeting.greeting(~T[16:59:59]) == "Good afternoon"
    end

    test "evening starts at 17:00 and ends at 20:59" do
      assert Greeting.greeting(~T[17:00:00]) == "Good evening"
      assert Greeting.greeting(~T[20:59:59]) == "Good evening"
    end

    test "night starts at 21:00 and wraps to 04:59" do
      assert Greeting.greeting(~T[21:00:00]) == "Good night"
      assert Greeting.greeting(~T[04:59:59]) == "Good night"
    end
  end
end
