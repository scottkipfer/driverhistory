defmodule CLI do
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
