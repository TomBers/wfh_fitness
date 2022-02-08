defmodule Days do

  def gen_dates(start_date, exercises, gap \\ 1, include_weekends \\ true, missed_days \\ []) do
    exercises
    |> Enum.with_index()
    |> Enum.map(fn {exercise, indx} -> ExerciseSet.add_todo_date(exercise, Date.add(start_date, indx * gap)) end)
    |> correct_for_missed_daya(missed_days)
    |> deal_with_weekends(gap, include_weekends)
  end

  def correct_for_missed_daya(schedule, []) do
    schedule
  end

  def correct_for_missed_daya(schedule, missed_days) do
    {corrected_schedules, _acc} =
      schedule
    |> Enum.reduce(
         {[], 0},
         fn schedule, {past_schedules, acc} -> calc_missed_offset(schedule, {past_schedules, acc}, missed_days) end
       )
    corrected_schedules
  end

  def calc_missed_offset(schedule, {past_schedules, acc}, missed_days) do
    new_acc =
      if Enum.any?(missed_days, fn day -> day == schedule.todo_date end) do
        acc + 1
      else
        acc
      end
    {past_schedules ++ [ExerciseSet.add_todo_date(schedule, Date.add(schedule.todo_date, new_acc))], new_acc}
  end

  def deal_with_weekends(dated_schedule, _gap, true) do
    dated_schedule
  end

  def deal_with_weekends(dated_schedule, gap, false) do
    {ds, _offset} = correct_for_weekends(dated_schedule, gap)
    ds
  end


  #  def gen_continuous() do
  #    today = ~D[2022-01-08] #Date.utc_today()
  #    1..7
  #    |> Enum.with_index()
  #    |> Enum.map(fn {_exercise, indx} -> Date.add(today, indx) end)
  #  end
  #
  #  def gen_gap() do
  #    today = Date.utc_today()
  #    gap = 2
  #    1..7
  #    |> Enum.with_index()
  #    |> Enum.map(fn {_exercise, indx} -> Date.add(today, indx * gap) end)
  #  end
  #
  #  def gen_weekends do
  #    gen_continuous()
  #    |> correct_for_weekends()
  #  end

  def correct_for_weekends(schedule, gap) do
    schedule
    |> Enum.reduce(
         {[], 0},
         fn schedule, {past_schedules, acc} -> calc_date_offset(schedule, {past_schedules, acc}, gap) end
       )
  end

  #  Catch case when we start on a Weekend
  def calc_date_offset(schedule, {[], 0}, _gap) do
    case Date.day_of_week(schedule.todo_date) do
      7 -> {[ExerciseSet.add_todo_date(schedule, Date.add(schedule.todo_date, 1))], 1}
      6 -> {[ExerciseSet.add_todo_date(schedule, Date.add(schedule.todo_date, 2))], 2}
      _ -> {[schedule], 0}
    end
  end

  def calc_date_offset(schedule, {past_schedules, acc}, gap) do
    new_acc = change_acc(Date.add(schedule.todo_date, acc), acc, gap)
    {past_schedules ++ [ExerciseSet.add_todo_date(schedule, Date.add(schedule.todo_date, new_acc))], new_acc}
  end

  #  We don't want to double account for Sat and Sunday
  def change_acc(date, acc, 1) do
    case Date.day_of_week(date) do
      6 -> acc + 2
      _ -> acc
    end
  end

  def change_acc(date, acc, gap) do
    case Date.day_of_week(date) do
      7 -> acc + 1
      6 -> acc + 2
      _ -> acc
    end
  end

end