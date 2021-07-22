import strformat
from strutils import startsWith, toLowerAscii
from os import getEnv, commandLineParams, getCurrentDir, walkFiles
from os import splitPath, splitFile
from envs import getEnvs, validEnvironmentFile

let log = open("log.txt", fmAppend)
log.writeLine("------- start -----")


let actions = ["activate", "create", "remove", "list"]


proc getPossibleActions(current: string) =
    for action in actions:
        if startsWith(action, current):
            echo action


proc isValidAction(argument: string): bool =
    for action in actions:
        if action == argument:
            return true

    return false


proc isYamlExtention(filePath: string): bool =
    var (_, _, ext) = splitFile(filePath)
    ext = toLowerAscii(ext)

    return ext == ".yml" or ext == ".yaml"


proc matchingEnvFiles(prefix: string) =
    # all matching conda environment files
    for filePath in walkFiles(&"{getCurrentDir()}/{prefix}*"):
        let (_, fileName) = splitPath(filePath)

        if not fileName.startsWith(prefix):
            continue

        if not isYamlExtention(fileName):
            continue

        if not validEnvironmentFile(filePath):
            continue

        echo fileName


proc getPossibleRemoveActivateArgs(prefix: string) =
    matchingEnvFiles(prefix)

    # suggest all matching conda environments
    for env in getEnvs():
        if env.startsWith(prefix):
            echo env


proc getPossibleActionArgs(action, argumentPrefix: string) =
    case action
    of "activate", "remove":
        getPossibleRemoveActivateArgs(argumentPrefix)
    of "create":
        matchingEnvFiles(argumentPrefix)



let args = commandLineParams()
let current = args[1]
let prev = args[2]

log.writeLine(&"current '{current}' prev '{prev}'")

#import strformat
#echo &"'{args[0]}' '{args[1]}' '{args[2]}'"
#quit(1)

if prev == "tst":
    getPossibleActions(current)
elif isValidAction(prev):
    getPossibleActionArgs(prev, current)

#let x = getEnv("COMP_LINE")
#echo &"COMP_LINE '{x}'"
#echo &"prev '{prev}' current '{current}'"
#echo "heh"

log.close()
