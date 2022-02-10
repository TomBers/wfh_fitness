defmodule GenProgram do


  def gen({:ok, params}) do
    exercises = lookup_exercises(params.exercises)
    p = Schedule.gen_program(exercises, params.reps, params.max_weight, params.weight_increments, params.repeat_count)
    Days.gen_dates(params.start_date, p, params.day_gap, params.include_weekends, get_missed_days(params.missed_days))
  end

  def gen(_error) do
    %{}
  end

  def get_missed_days(nil) do
    []
  end

  def get_missed_days(missed_days) do
    missed_days
  end

  def lookup_exercises(exercises_by_index) do
    exercises_by_index
    |> Enum.map(fn idx -> exercises_index(idx) end)
  end

  def exercises do
    %{"Pressups" => 1, "Situps" => 2, "Pullups" => 3}
  end

  def reps do
    1..12
  end

  def exercises_index(n) do
    {val, idx} = Enum.find(exercises(), fn {k, v} -> v == n end)
    val
  end

end