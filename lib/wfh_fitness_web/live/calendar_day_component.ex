defmodule CalendarDayComponent do
  use Phoenix.LiveComponent
  use Timex

  def render(assigns) do
    ~H"""
    <div {%{"phx-click" => "pick-date", "phx-value-date" => @day.date}}>
      <%= Timex.format!(@day.date, "%d", :strftime) %>
      <%= if @day.program do %>
        <p>💪</p>
        <%= if is_selected(@day.date, @selected_date) do %>
          <div class="align-items-end">
            <button {%{"phx-click" => "skip-day", "phx-value-date" => @day.date, "class" => "btn btn-sm"}}>Skip</button>
            <button {%{"phx-click" => "pick-date", "phx-value-date" => @day.date, "class" => "btn btn-sm"}}>Close</button>
          </div>
          <table class="table-fixed">
            <thead>
              <tr>
                <th class="p-2 text-left font-bold min-w-[50%]">Exercise</th>
                <th class="p-2 text-left font-bold">Reps</th>
                <th class="p-2 text-left font-bold">Weight</th>
              </tr>
            </thead>
            <tbody>
              <%= for exercise <- @day.program.exercises do %>
                <tr>
                  <td class="p-2"><%= exercise.name %></td>
                  <td class="p-2"><%= exercise.reps %></td>
                  <td class="p-2"><%= exercise.weight %></td> </tr>
              <% end %>
            </tbody>
          </table>
      <% end %>
      <% end %>
    </div>
    """
  end

  defp is_selected(ndt, nil) do
    false
  end

  defp is_selected(ndt, selected_date) do
    ndt == selected_date
  end
end
