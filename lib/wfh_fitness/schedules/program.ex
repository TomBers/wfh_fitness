defmodule WfhFitness.Schedules.Program do
  use Ecto.Schema
  import Ecto.Changeset

  schema "programs" do
    field :day_gap, :integer
    field :exercises, {:array, :integer}
    field :max_weight, :integer
    field :missed_days, {:array, :date}
    field :repeat_count, :integer
    field :include_weekends, :boolean
    field :reps, {:array, :integer}
    field :start_date, :date
    field :weight_increments, :integer

    timestamps()
  end

  @doc false
  def changeset(program, attrs) do

    program
    |> cast(attrs, [:start_date, :day_gap, :max_weight, :weight_increments, :repeat_count, :include_weekends, :reps, :missed_days, :exercises])
    |> validate_required([:start_date, :day_gap, :max_weight, :weight_increments, :repeat_count, :reps, :include_weekends, :exercises])
  end
end
