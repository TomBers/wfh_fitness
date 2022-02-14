defmodule Calendar do
  use Phoenix.LiveComponent
  use Timex

  def render(assigns) do
    ~H"""
      <div class="container">
        <div class="grid grid-cols-7">
          <%= for day_name <- @day_names do %>
            <div class="text-lg p-2 text-slate-400 bg-slate-800 border border-gray-200"><%= day_name %></div>
          <% end %>
          <%= for week <- @week_rows do %>
            <%= for day <- week do %>
              <div class={day_class(day, @current_date, @program)}>
                <.live_component module={CalendarDayComponent} day={day} selected_date={@selected_date} day_class={day_class(day, @current_date, @program)} id={day.date} />
              </div>
            <% end %>
          <% end %>
        </div>
      </div>
    """
  end

  defp day_class(day, current_date, program) do
    cond do
      today?(day) ->
        "text-sm p-2 text-gray-600 border border-gray-200 bg-green-300 hover:bg-green-200 cursor-pointer"

      missed?(day, program) ->
        "text-sm p-2 border border-gray-200 bg-red-200 cursor-not-allowed"

      other_month?(day, current_date) ->
        "text-sm p-2 text-gray-400 border border-gray-200 bg-gray-200 cursor-not-allowed"

      true ->
        "text-sm p-2 text-slate-400 border border-gray-200 bg-slate-800 hover:bg-slate-600 cursor-pointer"
    end
  end

  defp today?(day) do
    day.date == Date.utc_today()
  end

  defp missed?(_day, nil) do
    false
  end

  defp missed?(day, program) do
    md =
      if is_nil(program.missed_days) do
        []
      else
        program.missed_days
      end

    Enum.any?(md, fn missed -> missed == day.date end)
  end

  defp other_month?(day, current_date) do
    Date.compare(Date.beginning_of_month(day.date), Date.beginning_of_month(current_date)) != :eq
  end
end
