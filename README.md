# Driverhistory

## Problem Statement

Let's write some code to track driving history for people.

The code will process an input file. You can either choose to accept the input via stdin (e.g. if you're using Ruby `cat input.txt | ruby yourcode.rb`), or as a file name given on the command line (e.g. `ruby yourcode.rb input.txt`). You can use any programming language that you want. Please choose a language that allows you to best demonstrate your programming ability.

Each line in the input file will start with a command. There are two possible commands.

The first command is Driver, which will register a new Driver in the app. Example:

`Driver Dan`

The second command is Trip, which will record a trip attributed to a driver. The line will be space delimited with the following fields: the command (Trip), driver name, start time, stop time, miles driven. Times will be given in the format of hours:minutes. We'll use a 24-hour clock and will assume that drivers never drive past midnight (the start time will always be before the end time). Example:

`Trip Dan 07:15 07:45 17.3`

Discard any trips that average a speed of less than 5 mph or greater than 100 mph.

Generate a report containing each driver with total miles driven and average speed. Sort the output by most miles driven to least. Round miles and miles per hour to the nearest integer.

Example input:

```
Driver Dan
Driver Alex
Driver Bob
Trip Dan 07:15 07:45 17.3
Trip Dan 06:12 06:32 21.8
Trip Alex 12:01 13:16 42.0
```

Expected output:

```
Alex: 42 miles @ 34 mph
Dan: 39 miles @ 47 mph
Bob: 0 miles
```

## Assumptions

 - Files will be in the correct format.  The following will never happen:
 ```
 Driver 1234
 Trip Dan text text text
 Trip Dan aa:bb cc:dd %$^
 ect...
 ```

 - Unknown commands will be skipped
 - Commands are case sensitive. `driver` or `trip` will be skipped.
 - Drivers will always be created before Trips are added. The following will never happen:
 ```
 Trip Dan 12:30 12:45 20
 Trip Dan
 ```

## Derived Requirements

- Must be able to parse command line arguments
- Show help message if no filename is passed
- Handle a wrong file name
- Trips with speeds over 100mph will be ignored
- Trips with speeds under 5mph will be ignored
- Do not output '@ X mph' if no trips have been added to entry


## Installation

To run this application you must have Erlang installed on your computer.

It is recommended to install Elixir in order to generate documentation and run tests.

follow the directions at https://elixir-lang.org/install.html or if you have brew on a MacOS run:

```
$ brew update
$ brew install elixir
```

this will also install Erlang.

To verify installation run:

```
$ elixir --version
```


Once installed you can build the application by running:
```
$ mix escript.build
```

Then to run the program
```
$ ./driverhistory <path-to-file>
```

## Tests

To run tests make sure elixir is installed and run

```
$ mix test
```

## Documentation

To view documentation run:
```
$ mix docs
```

You can then open `driverhistory/docs/index.html`

