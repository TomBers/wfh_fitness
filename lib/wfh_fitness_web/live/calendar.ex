defmodule Calendar do
  use Phoenix.LiveComponent
  use Timex

  def render(assigns) do
    ~H"""
    <div class="container">
        <table class="w-full mt-4 border border-gray-200 rounded-lg shadow-lg">
            <thead>
            <tr>
                <%= for day_name <- @day_names do %>
                <th class="text-xs p-2 text-gray-600 border border-gray-200">
                    <%= day_name %>
                </th>
                <% end %>
            </tr>
            </thead>
            <tbody>
            <%= for week <- @week_rows do %>
            <tr>
                <%= for day <- week do %>
                 <.live_component module={CalendarDayComponent} day={day} selected_date={@selected_date} day_class={day_class(day, @current_date, @program)} id={day.date} />
                <% end %>
            </tr>
            <% end %>
            </tbody>
        </table>
    </div>
    """
  end

  defp day_class(day, current_date, program) do
    cond do
      today?(day) ->
        "text-xs p-2 text-gray-600 border border-gray-200 bg-green-200 hover:bg-green-300 cursor-pointer"

      missed?(day, program) ->
        "text-xs p-2 border border-gray-200 bg-red-200 cursor-not-allowed"

      other_month?(day, current_date) ->
        "text-xs p-2 text-gray-400 border border-gray-200 bg-gray-200 cursor-not-allowed"

      true ->
        "text-xs p-2 text-gray-600 border border-gray-200 bg-white hover:bg-blue-100 cursor-pointer"
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
