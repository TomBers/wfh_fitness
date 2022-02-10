defmodule WfhFitnessWeb.PageLive do
  use WfhFitnessWeb, :live_view

  @week_start_at :mon
  @include_weekends false
  @day_gap 1

  @impl true
  def mount(_params, _session, socket) do
    current_date = Date.utc_today()
    program = WfhFitness.Schedules.get_program(1)
    schedule = program |> GenProgram.gen()

    assigns = [
      conn: socket,
      current_date: current_date,
      selected_date: nil,
      day_names: day_names(@week_start_at),
      week_rows: week_rows(current_date, schedule),
      schedule: schedule,
      program: program
    ]

    {:ok, assign(socket, assigns)}
  end

  defp day_names(:sun),
       do: [7, 1, 2, 3, 4, 5, 6]
           |> Enum.map(&Timex.day_shortname/1)
  defp day_names(_),
       do: [1, 2, 3, 4, 5, 6, 7]
           |> Enum.map(&Timex.day_shortname/1)

  defp week_rows(current_date, schedule) do
    first =
      current_date
      |> Timex.beginning_of_month()
      |> Timex.beginning_of_week(@week_start_at)

    last =
      current_date
      |> Timex.end_of_month()
      |> Timex.end_of_week(@week_start_at)

    Timex.Interval.new(from: first, until: last)
    |> Enum.map(& %{date: NaiveDateTime.to_date(&1), program: Schedule.get_program(&1, schedule)})
    |> Enum.chunk_every(7)
  end

  def handle_event("prev-month", _, socket) do
    current_date = Date.add(socket.assigns.current_date, -31) |> Date.beginning_of_month()

    assigns = [
      current_date: current_date,
      week_rows: week_rows(current_date, socket.assigns.schedule)
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("today", _, socket) do
    current_date = Date.utc_today()

    assigns = [
      current_date: current_date,
      week_rows: week_rows(current_date, socket.assigns.schedule)
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("next-month", _, socket) do
    current_date = Date.add(socket.assigns.current_date, 31) |> Date.beginning_of_month()
    assigns = [
      current_date: current_date,
      week_rows: week_rows(current_date, socket.assigns.schedule)
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("pick-date", %{"date" => date}, socket) do
    new_selected_date =
      if is_nil(socket.assigns.selected_date) do
        Date.from_iso8601!(date)
        else
        nil
      end
    {:noreply, assign(socket, selected_date: new_selected_date)}
  end

  def handle_event("skip-day", %{"date" => date_str}, socket) do
#    TODO: Store skipped days in Db, and then get new schedule (get and update??)
    current_date = Date.utc_today()
    date = Date.from_iso8601!(date_str)

#    TODO - this does not return the updated program need to see if there is a way to update and get in 1 query
    {:ok, program} = WfhFitness.Schedules.add_missed_date(socket.assigns.program, date)

    assigns = [
      program: program,
      schedule: program |> GenProgram.gen()
    ]
    {:noreply, assign(socket, assigns)}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not WfhFitnessWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
