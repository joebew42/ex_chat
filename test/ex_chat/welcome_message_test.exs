defmodule ExChat.WelcomeMessageTest do
  use ExUnit.Case, async: true

  alias ExChat.WelcomeMessage

  test "includes the number of days to Christmas on an ordinary day" do
    a_day_far_from_christmas = ~D[2026-12-01]

    message = WelcomeMessage.for_user("a_room", "a_user", a_day_far_from_christmas)

    assert message == "welcome to the a_room chat room, a_user! It is 24 days to Christmas 🎅"
  end

  test "counts the days to Christmas from the given date" do
    a_hundred_and_thirty_days_before_christmas = ~D[2026-08-17]

    message =
      WelcomeMessage.for_user("a_room", "a_user", a_hundred_and_thirty_days_before_christmas)

    assert message == "welcome to the a_room chat room, a_user! It is 130 days to Christmas 🎅"
  end

  test "celebrates on Christmas day" do
    christmas_day = ~D[2026-12-25]

    message = WelcomeMessage.for_user("a_room", "a_user", christmas_day)

    assert message ==
             "welcome to the a_room chat room, a_user! It is Christmas! Ho Ho merry Christmas 🎄"
  end

  test "reminds about the shopping in the few days before Christmas" do
    three_days_before_christmas = ~D[2026-12-22]

    message = WelcomeMessage.for_user("a_room", "a_user", three_days_before_christmas)

    assert message ==
             "welcome to the a_room chat room, a_user! Ho ho a_user! Have you done your Christmas shopping yet? 🎁"
  end

  test "counts to next year's Christmas when the date is after December 25th" do
    the_day_after_christmas = ~D[2026-12-26]

    message = WelcomeMessage.for_user("a_room", "a_user", the_day_after_christmas)

    assert message == "welcome to the a_room chat room, a_user! It is 364 days to Christmas 🎅"
  end
end
