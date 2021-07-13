import strformat
from os import fileExists
from envs import getEnvironmentName, InvalidEnvironmentFile


proc isCondaEnvironmentFile(filePath: string): bool =
    if not fileExists(filePath):
        return false

    try:
        # try to parse specified file to
        # check if it containes valid YAML
        discard getEnvironmentName(filePath)
    except InvalidEnvironmentFile:
        echo &"ignoring '{filePath}', failed to parse as conda environment file"

        return false

    return true


proc getCondaCommand(name: string): string =
    if isCondaEnvironmentFile(name):
        return &"conda env create -f {name}"

    &"conda create --name {name}"


proc createEnvironment*(name: string) =
    echo getCondaCommand(name)
