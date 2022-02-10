defmodule WfhFitness.Schedules.Program do
  use Ecto.Schema
  import Ecto.Changeset

  schema "programs" do
    field :day_gap, :integer
    field :exercises, {:array, :integer}
    field :include_weekends, :boolean, default: false
    field :max_weight, :integer
    field :missed_days, {:array, :date}
    field :name, :string
    field :repeat_count, :integer
    field :reps, {:array, :integer}
    field :start_date, :date
    field :weight_increments, :integer

    timestamps()
  end

  @doc false
  def changeset(program, attrs) do
    program
    |> cast(attrs, [:name, :start_date, :day_gap, :max_weight, :weight_increments, :repeat_count, :reps, :include_weekends, :missed_days, :exercises])
    |> validate_required([:name, :start_date, :day_gap, :max_weight, :weight_increments, :repeat_count, :reps, :include_weekends, :exercises])
  end
end
