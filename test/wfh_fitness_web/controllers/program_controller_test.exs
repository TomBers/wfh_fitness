defmodule WfhFitnessWeb.ProgramControllerTest do
  use WfhFitnessWeb.ConnCase

  import WfhFitness.SchedulesFixtures

  @create_attrs %{
    day_gap: 42,
    exercises: [],
    include_weekends: true,
    max_weight: 42,
    missed_days: [],
    name: "some name",
    repeat_count: 42,
    reps: [],
    start_date: ~D[2022-02-09],
    weight_increments: 42
  }
  @update_attrs %{
    day_gap: 43,
    exercises: [],
    include_weekends: false,
    max_weight: 43,
    missed_days: [],
    name: "some updated name",
    repeat_count: 43,
    reps: [],
    start_date: ~D[2022-02-10],
    weight_increments: 43
  }
  @invalid_attrs %{
    day_gap: nil,
    exercises: nil,
    include_weekends: nil,
    max_weight: nil,
    missed_days: nil,
    name: nil,
    repeat_count: nil,
    reps: nil,
    start_date: nil,
    weight_increments: nil
  }

  describe "index" do
    test "lists all programs", %{conn: conn} do
      conn = get(conn, Routes.program_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Programs"
    end
  end

  describe "new program" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.program_path(conn, :new))
      assert html_response(conn, 200) =~ "New Program"
    end
  end

  describe "create program" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.program_path(conn, :create), program: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.program_path(conn, :show, id)

      conn = get(conn, Routes.program_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Program"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.program_path(conn, :create), program: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Program"
    end
  end

  describe "edit program" do
    setup [:create_program]

    test "renders form for editing chosen program", %{conn: conn, program: program} do
      conn = get(conn, Routes.program_path(conn, :edit, program))
      assert html_response(conn, 200) =~ "Edit Program"
    end
  end

  describe "update program" do
    setup [:create_program]

    test "redirects when data is valid", %{conn: conn, program: program} do
      conn = put(conn, Routes.program_path(conn, :update, program), program: @update_attrs)
      assert redirected_to(conn) == Routes.program_path(conn, :show, program)

      conn = get(conn, Routes.program_path(conn, :show, program))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, program: program} do
      conn = put(conn, Routes.program_path(conn, :update, program), program: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Program"
    end
  end

  describe "delete program" do
    setup [:create_program]

    test "deletes chosen program", %{conn: conn, program: program} do
      conn = delete(conn, Routes.program_path(conn, :delete, program))
      assert redirected_to(conn) == Routes.program_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.program_path(conn, :show, program))
      end
    end
  end

  defp create_program(_) do
    program = program_fixture()
    %{program: program}
  end
end
