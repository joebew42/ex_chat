defmodule ExChat.WelcomeMessageTest do
  use ExUnit.Case, async: true

  alias ExChat.WelcomeMessage

  test "counts the days to Christmas on an ordinary day" do
    a_day_outside_the_christmas_period = ~D[2026-09-08]

    message = WelcomeMessage.for_user("default", "a-user", a_day_outside_the_christmas_period)

    assert message == "welcome to the default chat room, a-user! It is 108 days to Christmas 🎅"
  end

  test "welcomes the user to the room they joined by name" do
    a_day_outside_the_christmas_period = ~D[2026-09-08]

    message =
      WelcomeMessage.for_user("a_chat_room", "charlie", a_day_outside_the_christmas_period)

    assert message ==
             "welcome to the a_chat_room chat room, charlie! It is 108 days to Christmas 🎅"
  end

  test "counts the days to Christmas the day before the shopping window opens" do
    the_day_before_the_shopping_window = ~D[2026-12-17]

    message = WelcomeMessage.for_user("default", "a-user", the_day_before_the_shopping_window)

    assert message == "welcome to the default chat room, a-user! It is 8 days to Christmas 🎅"
  end

  test "reminds about shopping without a day count when the shopping window opens" do
    the_day_the_shopping_window_opens = ~D[2026-12-18]

    message = WelcomeMessage.for_user("default", "a-user", the_day_the_shopping_window_opens)

    assert message ==
             "welcome to the default chat room, a-user! Ho ho a-user! Have you done your Christmas shopping yet? 🎁"
  end

  test "reminds about shopping without a day count on Christmas Eve" do
    christmas_eve = ~D[2026-12-24]

    message = WelcomeMessage.for_user("default", "a-user", christmas_eve)

    assert message ==
             "welcome to the default chat room, a-user! Ho ho a-user! Have you done your Christmas shopping yet? 🎁"
  end

  test "greets Christmas without a day count on Christmas Day" do
    christmas_day = ~D[2026-12-25]

    message = WelcomeMessage.for_user("default", "a-user", christmas_day)

    assert message ==
             "welcome to the default chat room, a-user! It is Christmas! Ho Ho merry Christmas 🎄"
  end

  test "greets Christmas on any year's Christmas Day" do
    christmas_day_the_following_year = ~D[2027-12-25]

    message = WelcomeMessage.for_user("default", "a-user", christmas_day_the_following_year)

    assert message ==
             "welcome to the default chat room, a-user! It is Christmas! Ho Ho merry Christmas 🎄"
  end

  test "counts the days to next Christmas on Boxing Day" do
    boxing_day = ~D[2026-12-26]

    message = WelcomeMessage.for_user("default", "a-user", boxing_day)

    assert message == "welcome to the default chat room, a-user! It is 364 days to Christmas 🎅"
  end

  test "counts the days to next Christmas across a leap year" do
    boxing_day_before_a_leap_year = ~D[2027-12-26]

    message = WelcomeMessage.for_user("default", "a-user", boxing_day_before_a_leap_year)

    assert message == "welcome to the default chat room, a-user! It is 365 days to Christmas 🎅"
  end

  test "defaults to today when no date is given" do
    message = WelcomeMessage.for_user("default", "a-user")

    assert String.starts_with?(message, "welcome to the default chat room, a-user! ")
  end

  test "renders one of the three seasonal forms on every date" do
    every_date_over_three_years = Date.range(~D[2026-01-01], ~D[2028-12-31])

    unrecognised =
      Enum.reject(every_date_over_three_years, fn date ->
        "welcome to the default chat room, a-user! " <> clause =
          WelcomeMessage.for_user("default", "a-user", date)

        clause == "It is Christmas! Ho Ho merry Christmas 🎄" or
          clause == "Ho ho a-user! Have you done your Christmas shopping yet? 🎁" or
          clause =~ ~r/^It is \d+ days to Christmas 🎅$/u
      end)

    assert unrecognised == []
  end

  test "never counts zero or negative days to Christmas" do
    every_date_over_three_years = Date.range(~D[2026-01-01], ~D[2028-12-31])

    countdowns =
      for date <- every_date_over_three_years,
          captures =
            Regex.run(
              ~r/It is (\d+) days to Christmas 🎅/u,
              WelcomeMessage.for_user("default", "a-user", date)
            ),
          do: String.to_integer(Enum.at(captures, 1))

    assert Enum.min(countdowns) == 8
    assert Enum.max(countdowns) == 365
  end
end
