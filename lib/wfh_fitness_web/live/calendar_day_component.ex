defmodule CalendarDayComponent do
  use Phoenix.LiveComponent
  use Timex

  def render(assigns) do
    assigns = Map.put(assigns, :day_class, day_class(assigns))

    ~H"""
    <td {%{"phx-click" => "pick-date", "phx-value-date" => @day.date, "class" => @day_class}}>
      <%= Timex.format!(@day.date, "%d", :strftime) %>
      <%= if @day.program do %>
        <p>💪</p>
        <%= if is_selected(@day.date, @selected_date) do %>
          <button {%{"phx-click" => "skip-day", "phx-value-date" => @day.date, "class" => "btn"}}>Skip</button>
          <table class="min-w-full shadow-md rounded">
            <thead class="bg-gray-50">
              <tr>
                <th class="p-4 text-left font-bold">Exercise</th>
                <th class="p-4 text-left font-bold">Reps</th>
                <th class="p-4 text-left font-bold">Weight</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-gray-300">
              <%= for exercise <- @day.program.exercises do %>
                <tr>
                  <td class="p-4"><%= exercise.name %></td>
                  <td class="p-4"><%= exercise.reps %></td>
                  <td class="p-4"><%= exercise.weight %></td> </tr>
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
    ndt == selected_date
  end

  defp today?(assigns) do
    assigns.day.date == Date.utc_today()
  end

  defp other_month?(assigns) do
    #      Map.take(assigns.day.date, [:month, :year]) != Map.take(assigns.current_date, [:month, :year])
    #    assigns.day.date.month != assigns.current_date.month
    false
  end
end
