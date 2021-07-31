# cnda

An unofficial command line utility for managing `conda` environments.
Provides a simple and easy to remember syntax for most common everyday operations.
Supports completion for all arguments when using bash shell.

# Cheat Sheet

Activate an environment:

    cnda activate <myenv>

Activate an environment from a file:

    cnda activate environment.yml

Create new environment:

    cnda create <myenv>

Create environment from a file:

    cnda create environment.yml

Remove an environment:

    cnda remove <myenv>

Remove environment defined in a file:

    cnda remove environment.yml


# Usage

    cnda <command> <argument>

## Commands

    cnda activate <env-name> | <env-file>

Activate a conda environment.
The environment to activate can be specified using it's name or by specifying the environment.yml file where it is defined.

    cnda create <env-name> | <env-file>

Create new conda environment.
If an environment.yml file is specified, creates the environment defined in the file. Otherwise an empty environment named \<env-name\> is created.

    cnda remove <env-name> | <env-file>

Remove an environment.
The environment to remove can be specified using it's name or by specifying the environment.yml file where it is defined.
