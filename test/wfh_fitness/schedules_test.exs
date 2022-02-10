defmodule WfhFitness.SchedulesTest do
  use WfhFitness.DataCase

  alias WfhFitness.Schedules

  describe "programs" do
    alias WfhFitness.Schedules.Program

    import WfhFitness.SchedulesFixtures

    @invalid_attrs %{day_gap: nil, exercises: nil, max_weight: nil, missed_days: nil, repeat_count: nil, reps: nil, start_date: nil, weight_increments: nil}

    test "list_programs/0 returns all programs" do
      program = program_fixture()
      assert Schedules.list_programs() == [program]
    end

    test "get_program!/1 returns the program with given id" do
      program = program_fixture()
      assert Schedules.get_program!(program.id) == program
    end

    test "create_program/1 with valid data creates a program" do
      valid_attrs = %{day_gap: 42, exercises: [], max_weight: 42, missed_days: [], repeat_count: 42, reps: [], start_date: ~D[2022-02-09], weight_increments: 42}

      assert {:ok, %Program{} = program} = Schedules.create_program(valid_attrs)
      assert program.day_gap == 42
      assert program.exercises == []
      assert program.max_weight == 42
      assert program.missed_days == []
      assert program.repeat_count == 42
      assert program.reps == []
      assert program.start_date == ~D[2022-02-09]
      assert program.weight_increments == 42
    end

    test "create_program/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedules.create_program(@invalid_attrs)
    end

    test "update_program/2 with valid data updates the program" do
      program = program_fixture()
      update_attrs = %{day_gap: 43, exercises: [], max_weight: 43, missed_days: [], repeat_count: 43, reps: [], start_date: ~D[2022-02-10], weight_increments: 43}

      assert {:ok, %Program{} = program} = Schedules.update_program(program, update_attrs)
      assert program.day_gap == 43
      assert program.exercises == []
      assert program.max_weight == 43
      assert program.missed_days == []
      assert program.repeat_count == 43
      assert program.reps == []
      assert program.start_date == ~D[2022-02-10]
      assert program.weight_increments == 43
    end

    test "update_program/2 with invalid data returns error changeset" do
      program = program_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedules.update_program(program, @invalid_attrs)
      assert program == Schedules.get_program!(program.id)
    end

    test "delete_program/1 deletes the program" do
      program = program_fixture()
      assert {:ok, %Program{}} = Schedules.delete_program(program)
      assert_raise Ecto.NoResultsError, fn -> Schedules.get_program!(program.id) end
    end

    test "change_program/1 returns a program changeset" do
      program = program_fixture()
      assert %Ecto.Changeset{} = Schedules.change_program(program)
    end
  end
end
