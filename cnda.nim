import strformat
from args import parseArgs, Action
from envs import get_envs
from create import create_environment


proc activate_environment(name: string) =
    echo &"activate {name}"


proc remove_environment(name: string) =
    echo &"remove {name}"


proc listEnvironments() =
    for envName in get_envs():
        echo envName


proc main() =
    let arguments = parseArgs()

    case arguments.action
    of Action.activate:
        activate_environment(arguments.name)
    of Action.remove:
        remove_environment(arguments.name)
    of Action.create:
        createEnvironment(arguments.name)
    of Action.list:
        listEnvironments()


main()
