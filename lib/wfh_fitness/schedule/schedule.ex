defmodule Schedule do
  @exercises ["Pullups", "Pressups", "Squats", "Step squats"]
  @reps [4, 5, 6, 7, 8]
  @max_weight 12
  @weight_divisions 0.5
  @continuous_days 2

  def gen_schedule(today, gap, include_weekends, skipped_days \\ []) do
    exercises = gen_program(@exercises, @reps, @max_weight, @weight_divisions, @continuous_days)

    Days.gen_dates(today, exercises, gap, include_weekends, skipped_days)
  end

  def get_program(ndt, schedule) do
    date = NaiveDateTime.to_date(ndt)
    Enum.find(schedule, fn s -> s.todo_date == date end)
  end

  def run do
    program = gen_program(@exercises, @reps, @max_weight, @weight_divisions, @continuous_days)
    program |> gen_dates()
  end

  def gen_dates(exercises) do
    today = Date.utc_today()
    include_weekends = false
    gap = 2
    Days.gen_dates(today, exercises, gap, include_weekends)
  end

  def gen_program(exercises, reps, max_weight, weight_divisions, continuous_days) do
    weight_steps = floor(max_weight / weight_divisions)

    0..weight_steps
    |> Enum.flat_map(fn weight -> add_for_weight(exercises, reps, weight_divisions * weight, continuous_days) end)
  end

  def add_for_weight(exercises, reps, weight, continuous_days) do
    reps
    |> Enum.flat_map(fn reps -> make_set(exercises, reps, weight, continuous_days) end)
  end

  def make_set(exercises, reps, weight, continuous_days) do
    1..continuous_days
    |> Enum.map(fn _x -> %ExerciseSet{exercises: make_exercises(exercises, reps, weight)} end)
  end

  def make_exercises(exercises, reps, weight) do
    Enum.map(exercises, fn ex -> %Exercise{name: ex, reps: reps, weight: weight} end)
  end

end