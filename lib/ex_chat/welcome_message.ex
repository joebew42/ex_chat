defmodule ExChat.WelcomeMessage do
  def for_user(room, user_id, today \\ Date.utc_today()) do
    "welcome to the #{room} chat room, #{user_id}! " <> christmas_clause(user_id, today)
  end

  defp christmas_clause(user_id, today) do
    case days_to_christmas(today) do
      0 -> "It is Christmas! Ho Ho merry Christmas 🎄"
      days when days in 1..5 -> "Ho ho #{user_id}! Have you done your Christmas shopping yet? 🎁"
      days -> "It is #{days} days to Christmas 🎅"
    end
  end

  defp days_to_christmas(today) do
    Date.diff(next_christmas(today), today)
  end

  defp next_christmas(today) do
    christmas = %Date{today | month: 12, day: 25}

    case Date.compare(today, christmas) do
      :gt -> %Date{christmas | year: christmas.year + 1}
      _ -> christmas
    end
  end
end
