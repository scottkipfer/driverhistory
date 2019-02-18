defmodule Trip do
  @moduledoc """
  This module handles the domain logic for creating,updating and printing the trip history.

  Trip history is stored as list with each entry containing driver's name, total distance traveled,
  total time spent driving and the average speed at which the driver traveled.
  """
  defstruct drv: "", d: 0, t: 0, avg_spd: 0
  @max_speed 100
  @min_speed 5

  @doc """
  Creates a new Driver with the default values and the drivers name.
  Adds driver to history.


  ## Examples

      iex> history = Trip.create_driver("Ricky Bobby", [])
      iex> Trip.create_driver("Cal Naughton Jr", history)
      [
        %Trip{drv: "Cal Naughton Jr", d: 0, t: 0, avg_spd: 0},
        %Trip{drv: "Ricky Bobby", d: 0, t: 0, avg_spd: 0}
      ]
  """
  def create_driver(name, history) do 
    [%Trip{:drv => name} | history]
  end

  @doc """
  Calculates Driver history based on previous aggregate and new trip.

  `Note:` Trips with an average speed under 5 mph or over 100 mph will NOT be added.

  ## Examples

      iex> history = Trip.create_driver("Ricky Bobby", [])
      iex> history = Trip.add_trip(["Ricky Bobby", "12:30", "14:30", "120"], history)
      iex> Trip.add_trip(["Ricky Bobby", "12:30", "14:30", "190"], history)
      [
        %Trip{drv: "Ricky Bobby", d: 310, t: 4.0, avg_spd: 78}
      ]

      # Too slow for trip to count
      iex> history = Trip.create_driver("Tortoise", [])
      iex> Trip.add_trip(["Tortoise", "12:30", "14:30", "1"], history)
      [
        %Trip{drv: "Tortoise", d: 0, t: 0, avg_spd: 0}
      ]

      # Too fast for trip to count
      iex> history = Trip.create_driver("Hare", [])
      iex> Trip.add_trip(["Hare", "12:30", "14:30", "220"], history)
      [
        %Trip{drv: "Hare", d: 0, t: 0, avg_spd: 0}
      ]
  """
  def add_trip([drv, t1, t2, d], history) do 
    time = trip_time(t1, t2)
    {dist,_} = Float.parse(d)
    validate_speed(dist / time)
    |> update_trip(%Trip{drv: drv, t: time, d: dist}, history)
  end

  @doc """
  Validates the speed based on the `@max_speed`and `@min_speed`

  `@max_speed` = 100

  `@min_speed` = 5

  ## Examples

      iex> Trip.validate_speed(120)
      :invalid

      iex> Trip.validate_speed(4)
      :invalid

      iex> Trip.validate_speed(60)
      :valid
  """
  def validate_speed(speed) when speed < @min_speed, do: :invalid
  def validate_speed(speed) when speed > @max_speed, do: :invalid
  def validate_speed(_), do: :valid

  defp update_trip(:invalid, _, history), do: history
  defp update_trip(:valid, trip, history) do
    idx = Enum.find_index(history, &(&1.drv == trip.drv))
    List.update_at(history, idx, &(update(trip, &1)))
  end

  defp update(trip, previous) do
    time = trip.t + previous.t;
    dist = trip.d + previous.d |> Float.round |> trunc
    avg_spd = dist / time |> Float.round |> trunc
    %Trip{:drv => trip.drv, :t =>  time, :d => dist, :avg_spd => avg_spd}
  end

  @doc """
  Calculates the amount of hours that a trip lasts.

  input format `"hh:mm"`

  `Note:` must be in military time

  ## Examples

      iex> Trip.trip_time("12:30", "13:30")
      1.0

      iex> Trip.trip_time("10:30", "14:30")
      4.0

      iex> Trip.trip_time("12:30", "13:00")
      0.5
  """
  def trip_time(t1, t2) do
    convert_to_hours(t2) - convert_to_hours(t1)
  end

  defp convert_to_hours(time) do
    [h, m] = String.split(time, ":")
             |> Enum.map(&String.to_integer/1)
    (h * 60 + m) / 60;
  end

  @doc """
  Formats the trip for printing

  Trips with 0 distance will not be formatted with `@ mph`

  ## Examples
  
      iex> history = Trip.create_driver("Ricky Bobby", [])
      iex> [ricky] = Trip.add_trip(["Ricky Bobby", "12:30", "14:30", "120"], history)
      iex> Trip.format(ricky)
      "Ricky Bobby: 120 miles @ 60 mph"

      iex> [ricky] = Trip.create_driver("Ricky Bobby", [])
      iex> Trip.format(ricky)
      "Ricky Bobby: 0 miles"
  """
  def format(%{:drv => drv, :d => 0}) do
    "#{drv}: 0 miles"
  end

  def format(trip) do
    dist_str = Integer.to_string(trip.d)
    avg_spd_str = Integer.to_string(trip.avg_spd)
    "#{trip.drv}: #{dist_str} miles @ #{avg_spd_str} mph"
  end

  @doc """
  Sorts the history of trips based on distance

  ## Examples

      iex> Trip.sort_by_distance([%{d: 1}, %{d: 3}, %{d: 2}])
      [%{d: 3}, %{d: 2}, %{d: 1}]
  """
  def sort_by_distance(history), do: Enum.sort(history, &(&1.d >= &2.d))
end
