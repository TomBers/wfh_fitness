defmodule WfhFitnessWeb.PageLiveTest do
  use WfhFitnessWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    #    Write tests here?
    #    assert disconnected_html =~ "Welcome to Phoenix!"
    #    assert render(page_live) =~ "Welcome to Phoenix!"
  end
end
