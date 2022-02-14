defmodule CalendarDayComponent do
  use Phoenix.LiveComponent
  use Timex

  def render(assigns) do
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

  defp is_selected(ndt, nil) do
    false
  end

  defp is_selected(ndt, selected_date) do
    ndt == selected_date
  end
end
