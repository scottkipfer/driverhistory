defmodule CLITest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "main test file from requirements" do
    assert capture_io(fn -> CLI.main(["test/files/test.txt"]) end) == "Alex: 42 miles @ 34 mph\nDan: 39 miles @ 47 mph\nBob: 0 miles\n"
  end

  test "Tests that program can handle invalid commands" do
    assert capture_io(fn -> CLI.main(["test/files/invalid.txt"]) end) == "Alex: 42 miles @ 34 mph\nDan: 39 miles @ 47 mph\nBob: 0 miles\n"
  end

  test "Tests that program can handle empty lines" do
    assert capture_io(fn -> CLI.main(["test/files/empty.txt"]) end) == "Alex: 42 miles @ 34 mph\nDan: 39 miles @ 47 mph\nBob: 0 miles\n"
  end

  test "if no file name is passed in then help text will be displayed" do
    assert capture_io(fn -> CLI.main([]) end) == "usage: $ ./driverhistory <filename.txt>\n"
  end

  test "if no file is found then error is displayed" do
    assert capture_io(fn -> CLI.main(["not_there.txt"]) end) == "ERROR: File Not Found\n"
  end

end
