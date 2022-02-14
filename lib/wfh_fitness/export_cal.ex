defmodule ExportCal do

  def gen_cal(n) do
    program = WfhFitness.Schedules.get_program(1)

    events =
      program
      |> GenProgram.gen()
      |> Enum.with_index()
      |> Enum.map(fn {event, indx} -> make_ical_event(event, indx) end)

    %ICalendar{events: events} |> ICalendar.to_ics
  end

#  def run do
#    program = WfhFitness.Schedules.get_program(1)
#
#    events =
#      program
#      |> GenProgram.gen()
#      |> Enum.with_index()
#      |> Enum.map(fn {event, indx} -> make_ical_event(event, indx) end)
#
#    ics = %ICalendar{events: events}
#          |> ICalendar.to_ics
#    File.write!("calendar.ics", ics)
#  end

  defp make_ical_event(event, indx) do
    %ICalendar.Event{
      summary: "WFH_fitness day #{indx + 1}",
      dtstart: event.todo_date,
      dtend: event.todo_date,
      description: description_from_exercises(event.exercises)
    }
  end

  def description_from_exercises(exercises) do
    exercises
    |> Enum.reduce("", fn ex, acc -> acc <> "#{ex.name} | #{ex.reps} reps | #{ex.weight} kg \n" end)
  end

end