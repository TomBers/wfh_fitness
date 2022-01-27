defmodule ExerciseSet do
  defstruct exercises: [], todo_date: nil, complete_date: nil

  def add_todo_date(exercise_set, todo_date) do
    Map.put(exercise_set, :todo_date, todo_date)
  end

end