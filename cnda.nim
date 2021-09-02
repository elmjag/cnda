from args import parseArgs, Action
from activate import activateEnvironment
from create import createEnvironment
from remove import removeEnvironment
from completions import echoCompletions


proc main() =
    let arguments = parseArgs()

    case arguments.action
    of Action.activate:
        activateEnvironment(arguments.name)
    of Action.remove:
        removeEnvironment(arguments.name)
    of Action.create:
        createEnvironment(arguments.name)
    of Action.completions:
        echoCompletions(arguments.previous, arguments.current)


main()
