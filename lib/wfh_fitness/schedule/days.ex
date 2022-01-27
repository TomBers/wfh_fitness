defmodule Days do

  def gen_continuous() do
    today = ~D[2022-01-08] #Date.utc_today()
    1..7
    |> Enum.with_index()
    |> Enum.map(fn {_exercise, indx} -> Date.add(today, indx) end)
  end

  def gen_gap() do
    gap = 3
    today = Date.utc_today()
    1..7
    |> Enum.with_index()
    |> Enum.map(fn {_exercise, indx} -> Date.add(today, indx * gap) end)
  end

  def gen_weekends do
    gen_continuous()
    |> correct_for_weekends()
  end

  def correct_for_weekends(dates) do
    dates
    |> Enum.reduce({[], 0}, fn date, {past_dates, acc} -> calc_date_offset(date, {past_dates, acc}) end)
  end

#  Catch case when we start on a Weekend
  def calc_date_offset(date, {[], 0}) do
    case Date.day_of_week(date) do
      7 -> {[Date.add(date, 1)], 1}
      6 -> {[Date.add(date, 2)], 2}
      _ -> {[date], 0}
      end
    end

  def calc_date_offset(date, {past_dates, acc}) do
    new_acc = change_acc(Date.add(date, acc), acc)
    {past_dates ++ [Date.add(date, new_acc)], new_acc }
  end

  def change_acc(date, acc) do
    case Date.day_of_week(date) do
      6 -> acc + 2
      _ -> acc
    end
  end

end