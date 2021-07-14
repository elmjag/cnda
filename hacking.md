# Developing cnda Tool

This document contains information usefull for developers of the `cnda` tool.


## Compiling

The cnda package is written in nim programming language with some shell glue code.
To compile this package you need [nim compiler](https://nim-lang.org/install.html) and optionally a `make` tool.

The cnda package depends on following nimble packages:

* yaml, version 0.15.0
* tempfile, version 0.1.7

Install them with following nimble command:

    nimble install yaml@0.15.0 tempfile@0.1.7

To compile `cnda`, run:

    nim compile cnda.nim

If you have `make` tool installed, you can compile with:

    make


## Architecture

Cnda package consists of two major parts, the `cnda` binary and `cnda()` shell function.

When user types `cnda [arguments..]`, the `cnda()` shell function is invoked.
The `cnda()` function will in turn run the `cnda` binary, passing it all specified arguments.
`cnda` binary will evaluate arguments and return a shell command to be exectued.
The `cnda()` shell function then will run the returned shell command.

The reason for having the wrapper `cnda()` function, is that for some actions the shell commands must be executed in the interactive shell session of the user.
In particular activate environmet action needs to manipulate user's current session.
This is not possible to do from `cnda` binary, as it does not have access to user's current shell session.

In general, the `cnda` binary generates shell commands that use the official _conda_ command line interface.


### Protocol Between cnda() and cnda

The `cnda()` shell function and `cnda` binary use stdout and exit code for communication.

The `cnda` binary returns it's results on the stdout.
If `cnda` binary exists with exit code 0, the `cnda()` function will run returned results as shell command.
If `cnda` binary exists with exit code 1, the `cnda()` function will print returned results.
The exit code 1 is used for error messages, or for actions where we only need to show some information to the user.
