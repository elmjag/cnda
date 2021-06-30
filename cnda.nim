import strformat
from args import parseArgs, Action
from envs import get_envs
from create import createEnvironment
from remove import removeEnvironment


proc activate_environment(name: string) =
    echo &"activate {name}"


proc listEnvironments() =
    for envName in get_envs():
        echo envName


proc main() =
    let arguments = parseArgs()

    case arguments.action
    of Action.activate:
        activate_environment(arguments.name)
    of Action.remove:
        removeEnvironment(arguments.name)
    of Action.create:
        createEnvironment(arguments.name)
    of Action.list:
        listEnvironments()


main()
