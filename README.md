# Driverhistory

## Problem Statement

Problem statement can be found at https://gist.github.com/dan-manges/1e1854d0704cb9132b74

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


Once installed you can build the application by going to the project root and running:
```
$ mix escript.build
```

Then to run the program:
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

## Thought Process

I chose to approach this problem from the stand point that we were provided an event log in the form of a text file and we needed to populate the read-side based on the commands recieved.  Instead of populating a read-side database that could be queryed against We were just outputing the results back to the command line.

This problem only required two commands: `Driver` and `Trip`.  The `Driver` command will create a new entry in the read side that will be affected by the succeding `Trip` commands.  Trip commands will apply trip values along with domain logic to the History entry for the corresponding driver.  The resulting history could be formated and prited out the the terminal.

## Design

The program consists of two modules:

#### Cli Module
This is the entry point into the application.  It handles parsing the command-line arguments as well as reading and processing the file read in from the arguments.

Once the file is parsed the module is respondible for reducing the commands down to a List containing the history for each Driver.  The Cli Module using the Trip Module to do any domain logic nescessary to reduce the commands to history.

Finally, once the history is produced the Cli Module outputs the entries back to the command line. The Cli Module uses the Trip Module to format the History Events correctly.

#### Trip Module
This contains domain logic to reduce commands to a Driver History

see the `docs` for more information.

## Technology Choice
After considering the problem statement and thinking about the design of the system I chose to use Elixir to create this command line application.  Although javascirpt is my strongest language, I have been quickly picking up Elixir over the last month by reading *Programming Elixir >= 1/6* by Dave Thomas.  This probelm is simple enough and I wanted to apply what I have learned so far.

#### Elixir Pros for this problem:

1. Functional Programing -  This is a programing paradigm that I am picking up and enjoy coding in.

2. Immutable Data - Having immutable data makes testing easy.  You don't have to to worry about data changing in unexpected ways.

3. Pattern Matching - Besides being fun to program in, Pattern Matching leads to cleaner code, straight forward recursion and easier decomposition.

4. Tooling -  Elixir comes with great tools that make testing and documentation really easy.  If you run the tests using `mix tests` you will see that `doc tests` were run.  `doc tests` allow you to put tests directly into the documentation.  This allows the user of the module to see examples of how each function is used and provides the security of tests.

#### Elixir Cons for this problem:

1. Needs to run on Erlang Vm - This requires the user to install Erlang and makes the program slow to start up. At least for this probelm there are other technology solutions that would be better for making a command line interface.

2. File size - The resulting executable for this project was around 1.6Mbs

3. Elixir's and Erlangs main draw is concurrent programing.  This is not needed for this problem so the real benfits of usign Elixir and Erlang are not seen.





