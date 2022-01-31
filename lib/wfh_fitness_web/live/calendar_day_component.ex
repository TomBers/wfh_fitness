defmodule CalendarDayComponent do
  use Phoenix.LiveComponent
  use Timex

  def render(assigns) do
    assigns = Map.put(assigns, :day_class, day_class(assigns))

    ~H"""
    <td {%{"phx-click" => "pick-date", "phx-value-date" => Timex.format!(@day.date, "%Y-%m-%d", :strftime), "class" => @day_class}}>
      <%= Timex.format!(@day.date, "%d", :strftime) %>
      <%= if @day.program do %>
        <p>.</p>
        <%= if is_selected(@day.date, @selected_date) do %>
          <table class="table-fixed">
            <thead>
              <tr>
                <th>Exercise</th>
                <th>Reps</th>
                <th>Weight</th>
              </tr>
            </thead>
            <tbody>
              <%= for exercise <- @day.program.exercises do %>
                <tr>
                  <td><%= exercise.name %></td>
                  <td><%= exercise.reps %></td>
                  <td><%= exercise.weight %></td> </tr>
              <% end %>
            </tbody>
          </table>
      <% end %>
      <% end %>
    </td>
    """
  end

  defp day_class(assigns) do
    cond do
      today?(assigns) ->
        "text-xs p-2 text-gray-600 border border-gray-200 bg-green-200 hover:bg-green-300 cursor-pointer"
      current_date?(assigns) ->
        "text-xs p-2 text-gray-600 border border-gray-200 bg-blue-100 cursor-pointer"
      other_month?(assigns) ->
        "text-xs p-2 text-gray-400 border border-gray-200 bg-gray-200 cursor-not-allowed"
      true ->
        "text-xs p-2 text-gray-600 border border-gray-200 bg-white hover:bg-blue-100 cursor-pointer"
    end
  end

  defp is_selected(ndt, nil) do
    false
  end

  defp is_selected(ndt, selected_date) do
    NaiveDateTime.to_date(ndt) == selected_date
  end

  defp current_date?(assigns) do
    Map.take(assigns.day.date, [:year, :month, :day]) == Map.take(assigns.current_date, [:year, :month, :day])
  end

  defp today?(assigns) do
    Map.take(assigns.day.date, [:year, :month, :day]) == Map.take(Timex.now, [:year, :month, :day])
  end

  defp other_month?(assigns) do
    Map.take(assigns.day.date, [:year, :month]) != Map.take(assigns.current_date, [:year, :month])
  end
end