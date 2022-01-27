defmodule WfhFitness.Repo do
  use Ecto.Repo,
    otp_app: :wfh_fitness,
    adapter: Ecto.Adapters.Postgres
end
