import strformat
from args import parseArgs, Action


proc activate_environment(name: string) =
    echo &"activate {name}"


proc main() =
    let arguments = parseArgs()

    case arguments.action
    of Action.activate:
        activate_environment(arguments.name)
    else:
        echo &"action '{arguments.action}' not implemented"


main()
