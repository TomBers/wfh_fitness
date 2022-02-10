defmodule WfhFitness.Repo.Migrations.CreatePrograms do
  use Ecto.Migration

  def change do
    create table(:programs) do
      add :start_date, :date
      add :day_gap, :integer
      add :max_weight, :integer
      add :weight_increments, :integer
      add :repeat_count, :integer
      add :include_weekends, :boolean
      add :reps, {:array, :integer}
      add :missed_days, {:array, :date}
      add :exercises, {:array, :integer}

      timestamps()
    end
  end
end
