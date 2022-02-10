defmodule WfhFitness.SchedulesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WfhFitness.Schedules` context.
  """

  @doc """
  Generate a program.
  """
  def program_fixture(attrs \\ %{}) do
    {:ok, program} =
      attrs
      |> Enum.into(%{
        day_gap: 42,
        exercises: [],
        include_weekends: true,
        max_weight: 42,
        missed_days: [],
        name: "some name",
        repeat_count: 42,
        reps: [],
        start_date: ~D[2022-02-09],
        weight_increments: 42
      })
      |> WfhFitness.Schedules.create_program()

    program
  end
end
