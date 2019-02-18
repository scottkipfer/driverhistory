defmodule TripTest do
  use ExUnit.Case
  doctest Trip

  test "Adds driver to history" do
    history = Trip.create_driver("Name", [])
    history = Trip.create_driver("Name2", history)
    assert length(history) == 2
  end

  test "Drivers are created with correct default values" do
    [history] = Trip.create_driver("Name", [])
    assert history.drv == "Name"
    assert history.avg_spd == 0
    assert history.d == 0
    assert history.t == 0
  end

  test "Adds trip to history" do
    history = Trip.create_driver("Name", [])
    [history] = Trip.add_trip(["Name", "12:30", "13:30", "20"], history)
    assert history.drv == "Name"
    assert history.avg_spd == 20
    assert history.t == 1.0
    assert history.d == 20
  end

  test "Correctly applies multiple trips" do
    history = Trip.create_driver("Name", [])
    history = Trip.add_trip(["Name", "12:30", "13:30", "20"], history)
    [history] = Trip.add_trip(["Name", "12:30", "14:30", "70"], history)
    assert history.drv == "Name"
    assert history.avg_spd == 30
    assert history.t == 3.0
    assert history.d == 90
  end

  test "Doesn't apply trip if it's speed is under 5mph" do
    history = Trip.create_driver("Name", [])
    [history] = Trip.add_trip(["Name", "12:30", "13:30", "1"], history)
    assert history.drv == "Name"
    assert history.avg_spd == 0
    assert history.t == 0
    assert history.d == 0
  end

  test "Doesn't apply trip if it's speed is over 100mph" do
    history = Trip.create_driver("Name", [])
    [history] = Trip.add_trip(["Name", "12:30", "13:30", "105"], history)
    assert history.drv == "Name"
    assert history.avg_spd == 0
    assert history.t == 0
    assert history.d == 0
  end


  test "Correctly formats history for output with no distances" do
    [history] = Trip.create_driver("Name", [])
    formatted = Trip.format(history) 
    assert formatted == "Name: 0 miles"
  end

  test "Correctly formats history for output with distance" do
    history = Trip.create_driver("Name", [])
    [history] = Trip.add_trip(["Name", "12:30", "13:30", "20"], history)
    formatted = Trip.format(history) 
    assert formatted == "Name: 20 miles @ 20 mph"
  end

  test "Sorts by distance" do
    sorted = Trip.sort_by_distance([%{d: 1}, %{d: 3}, %{d: 2}])
    assert sorted == [%{d: 3}, %{d: 2}, %{d: 1}]
  end
end
