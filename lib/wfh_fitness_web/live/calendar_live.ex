defmodule CalendarLive do
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
                 <.live_component module={CalendarDayComponent} day={day} selected_date={@selected_date} current_date={@current_date} id={day.date} />
                <% end %>
            </tr>
            <% end %>
            </tbody>
        </table>
    </div>
    """
  end
end
