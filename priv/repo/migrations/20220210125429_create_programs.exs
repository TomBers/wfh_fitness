defmodule WfhFitness.Repo.Migrations.CreatePrograms do
  use Ecto.Migration

  def change do
    create table(:programs) do
      add :name, :string
      add :start_date, :date
      add :day_gap, :integer
      add :max_weight, :integer
      add :weight_increments, :integer
      add :repeat_count, :integer
      add :reps, {:array, :integer}
      add :include_weekends, :boolean, default: false, null: false
      add :missed_days, {:array, :date}
      add :exercises, {:array, :integer}

      timestamps()
    end
  end
end
