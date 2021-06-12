import os
import tables

type
    Action* = enum
        unknown, activate, create, remove

    Arguments = ref object
        action*: Action
        name*: string



const actionName = toTable[string, Action](
    {
        "activate": Action.activate,
        "create": Action.create,
        "remove": Action.remove,
    })


proc usage() =
    echo "usage: TBD"
    quit(1)


proc getAction(arg: string): Action =
    if not actionName.hasKey(arg):
        return unknown

    return actionName[arg]


proc parseArgs*(): Arguments =
    let args = commandLineParams()

    if args.len <= 1:
        usage()

    result = Arguments(action: getAction(args[0]),
                       name: args[1])
