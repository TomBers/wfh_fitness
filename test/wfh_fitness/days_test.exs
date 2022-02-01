defmodule WfhFitness.DaysTest do
  use WfhFitness.DataCase

  @exercise %Exercise{name: "test", reps: 1, weight: 1}

  describe "test creating a simple exercise schedule" do
    test "test starting on monday for a week with no gaps including weekends" do
      exercises = gen_exercises(7)
      today = ~D[2022-01-03]
      schedule = Days.gen_dates(today, exercises)
      assert_simple_week(schedule, today)
    end

    test "test starting a saturday for a week with no gaps including weekends" do
      exercises =  gen_exercises(7)
      today = ~D[2022-01-08]
      schedule = Days.gen_dates(today, exercises)
      assert_simple_week(schedule, today)
    end

    test "test starting a sunday for a week with no gaps including weekends" do
      exercises =  gen_exercises(7)
      today = ~D[2022-01-09]
      schedule = Days.gen_dates(today, exercises)
      assert_simple_week(schedule, today)
    end

  end

  describe "schedule with gaps" do
    test "test starting on monday for a week every other day including weekends" do
      exercises = gen_exercises(7)
      today = ~D[2022-01-03]
      schedule = Days.gen_dates(today, exercises, 2)
      last_date = assert_gap_of_2(schedule, today)
      assert last_date == ~D[2022-01-15]
    end

    test "test starting a saturday for a week every other day including weekends" do
      exercises =  gen_exercises(7)
      today = ~D[2022-01-08]
      schedule = Days.gen_dates(today, exercises, 2)
      last_date = assert_gap_of_2(schedule, today)
      assert last_date == ~D[2022-01-20]
    end

    test "test starting a sunday for a week every other day including weekends" do
      exercises =  gen_exercises(7)
      today = ~D[2022-01-09]
      schedule = Days.gen_dates(today, exercises, 2)
      last_date = assert_gap_of_2(schedule, today)
      assert last_date == ~D[2022-01-21]
    end
  end

  describe "we can filter out weekends" do
    test "test starting on monday for a week with no gaps excluding weekends" do
      exercises = gen_exercises(7)
      today = ~D[2022-01-03]
      schedule = Days.gen_dates(today, exercises, 1, false)
      last = List.last(schedule)
      assert last.todo_date == ~D[2022-01-11]
    end

    test "test starting a saturday for a week with no gaps excluding weekends" do
      exercises =  gen_exercises(7)
      today = ~D[2022-01-08]
      schedule = Days.gen_dates(today, exercises, 1, false)
      last = List.last(schedule)
      assert last.todo_date == ~D[2022-01-18]
    end

    test "test starting a sunday for a week with no gaps excluding weekends" do
      exercises =  gen_exercises(7)
      today = ~D[2022-01-09]
      schedule = Days.gen_dates(today, exercises, 1, false)
      last = List.last(schedule)
      assert last.todo_date == ~D[2022-01-18]
    end
  end

  describe "we can have both a gap and a filter for weekends" do
    test "test starting on monday for a week every other day excluding weekends" do
      exercises = gen_exercises(7)
      today = ~D[2022-01-03]
      schedule = Days.gen_dates(today, exercises, 2, false)
      last = List.last(schedule)
      assert last.todo_date == ~D[2022-01-17]
    end

    test "test starting a saturday for a week every other day excluding weekends" do
      exercises =  gen_exercises(7)
      today = ~D[2022-01-08]
      schedule = Days.gen_dates(today, exercises, 2, false)
      last = List.last(schedule)
      assert last.todo_date == ~D[2022-01-24]
    end

    test "test starting a sunday for a week every other day excluding weekends" do
      exercises =  gen_exercises(7)
      today = ~D[2022-01-09]
      schedule = Days.gen_dates(today, exercises, 2, false)
      last = List.last(schedule)
      assert last.todo_date == ~D[2022-01-24]
    end
  end


  def gen_exercises(n) do
    1..n |> Enum.map(fn _x -> %ExerciseSet{exercises: [@exercise]} end)
  end

  def assert_simple_week(schedule, today) do
    assert length(schedule) == 7
    first = List.first(schedule)
    last = List.last(schedule)
    assert first.todo_date == today
    assert last.todo_date == Date.add(today, 6)
  end

  def assert_gap_of_2(schedule, today) do
    assert length(schedule) == 7
    first = List.first(schedule)
    last = List.last(schedule)
    assert first.todo_date == today
    assert last.todo_date == Date.add(today, 12)
    last.todo_date
  end

end