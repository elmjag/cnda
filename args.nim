import tables
import strformat
from os import commandLineParams, existsEnv


type
    Action* = enum
        activate, create, remove, list, completions

    Arguments = ref object
        case action*: Action
        of activate, create, remove: name * : string
        of completions: previous*, current*: string
        of list: discard

#
# module private types
#
type
    ActionFormat = tuple[kind: Action, numArgs: int]


const actionDescriptions* = toTable[string, ActionFormat](
    {
        "activate": (Action.activate, 1),
        "create": (Action.create, 1),
        "remove": (Action.remove, 1),
        "list": (Action.list, 0),
    })


proc usage() =
    echo "usage: cnda <action> [options]"
    quit(1)


proc parseArgs*(): Arguments =
    let args = commandLineParams()

    if existsEnv("COMP_LINE"):
        # the 'bash completions' mode detected
        return Arguments(action: completions, previous: args[2], current: args[1])

    if args.len < 1:
        usage()

    let actionArg = args[0]

    if not actionDescriptions.hasKey(actionArg):
        echo &"unknown action '{actionArg}'"
        quit(1)

    let actionDesc = actionDescriptions[actionArg]

    result = Arguments(action: actionDesc.kind)

    if actionDesc.numArgs == 0:
        return

    if args.len < 2:
        echo &"'{actionArg}' requires an argument"
        quit(1)

    result.name = args[1]
