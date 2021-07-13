from args import parseArgs, Action
from envs import get_envs
from activate import activateEnvironment
from create import createEnvironment
from remove import removeEnvironment


proc listEnvironments() =
    for envName in get_envs():
        echo envName

    # signal that environments list should be printed
    quit(1)


proc main() =
    let arguments = parseArgs()

    case arguments.action
    of Action.activate:
        activateEnvironment(arguments.name)
    of Action.remove:
        removeEnvironment(arguments.name)
    of Action.create:
        createEnvironment(arguments.name)
    of Action.list:
        listEnvironments()


main()
