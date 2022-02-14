defmodule WfhFitnessWeb.ProgramController do
  use WfhFitnessWeb, :controller

  alias WfhFitness.Schedules
  alias WfhFitness.Schedules.Program

  def index(conn, _params) do
    programs = Schedules.list_programs()
    render(conn, "index.html", programs: programs)
  end

  def new(conn, _params) do
    changeset = Schedules.change_program(%Program{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"program" => program_params}) do
    case Schedules.create_program(program_params) do
      {:ok, program} ->
        conn
        |> put_flash(:info, "Program created successfully.")
        |> redirect(to: Routes.program_path(conn, :show, program))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    program = Schedules.get_program!(id)
    render(conn, "show.html", program: program)
  end

  def edit(conn, %{"id" => id}) do
    program = Schedules.get_program!(id)
    changeset = Schedules.change_program(program)
    render(conn, "edit.html", program: program, changeset: changeset)
  end

  def download(conn, %{"id" => id}) do
    send_download(conn, {:binary, ExportCal.gen_cal(id)}, filename: "cal.ics")
  end

  def update(conn, %{"id" => id, "program" => program_params}) do
    program = Schedules.get_program!(id)

    case Schedules.update_program(program, program_params) do
      {:ok, program} ->
        conn
        |> put_flash(:info, "Program updated successfully.")
        |> redirect(to: Routes.program_path(conn, :show, program))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", program: program, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    program = Schedules.get_program!(id)
    {:ok, _program} = Schedules.delete_program(program)

    conn
    |> put_flash(:info, "Program deleted successfully.")
    |> redirect(to: Routes.program_path(conn, :index))
  end
end
