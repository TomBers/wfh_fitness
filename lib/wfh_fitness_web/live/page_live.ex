defmodule WfhFitnessWeb.PageLive do
  use WfhFitnessWeb, :live_view

  @week_start_at :mon
  @include_weekends false
  @day_gap 1

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
