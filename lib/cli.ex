defmodule CLI do
  @moduledoc """
  This module will parse the arguments passed in from the command line
  and attempt to parse a file in order to return driver history.

  #### Valid Commands

  The Driver command will create a new record in the trips history with the Drivers name.
  The Driver command is structured as follows:

      "Driver Dave"  

  The Trip command will be added to the aggregate of the driver history.
  The Trip command is structured as follows:

      "Trip Dave 12:30 12:45 20"

  #### Output
  Output will contain the aggregate of all the trips for each driver registered
  Output will be structured like:

      Driver: X miles @ Y mph

  or:

      Driver: 0 miles
  

  #### Considerations:
  Blank lines or lines not following the format listed above will be rejected and not affect the output.

  Drivers _must_ be created before trips can be added to them.

  #### Help 
  
  by passing no file name or passing `-h` or `--help` you will receive a help message on how to use the program

  #### Example
  
  Input

      Driver Dan
      Driver Alex
      Driver Bob
      Trip Dan 07:15 07:45 17.3
      Trip Dan 06:12 06:32 21.8
      Trip Alex 12:01 13:16 42.0

  Output

      Alex: 42 miles @ 34 mph
      Dan: 39 miles @ 47 mph
      Bob: 0 miles

  """

  @doc """
  Entry point into application.
  """
  def main(args) do
    args |> parse_args |> process_args
  end

  defp parse_args(args) do
    {_, args, _} = OptionParser.parse(args, switches: []) 
    args
  end

  defp process_args([file_name]) do
    File.read(file_name)
    |> process_file
  end

  defp process_args(_) do 
    IO.puts "usage: $ ./driverhistory <filename.txt>"
    System.halt(2)
  end

  defp process_file({:error, _}), do: IO.puts "ERROR: File Not Found"
  defp process_file({:ok, contents}) do
    contents
    |> convert_to_commands
    |> reduce_to_trips([])
    |> print_trips
  end

  defp convert_to_commands(contents) do
    String.split(contents, "\n", trim: true) 
    |> Enum.map(&(String.split/1))
  end

  defp reduce_to_trips([], history), do: Trip.sort_by_distance(history)
  defp reduce_to_trips([head | rest], history) do
    reduce_to_trips(rest, command(head, history))
  end

  defp command(["Driver", name], history) do
    Trip.create_driver(name, history)
  end

  defp command(["Trip", driver, t1, t2, d], history) do
    Trip.add_trip([driver, t1, t2, d], history)
  end

  defp command(_, history), do: history

  defp print_trips(results) do
    Enum.map(results, &Trip.format/1)
    |> Enum.map(&IO.puts/1)
  end
end
