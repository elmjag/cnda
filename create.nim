import strformat
from os import fileExists, execShellCmd
from streams import newFileStream
from yaml/dom import loadDom
from yaml/parser import YamlParserError


proc isCondaEnvironmentFile(filePath: string): bool =
    if not fileExists(filePath):
        return false

    try:
        # try to parse specified file to
        # check if it containes valid YAML
        discard loadDom(newFileStream(filePath))
    except YamlParserError:
        echo &"ignoring '{filePath}', failed to parse as yaml"

        return false

    return true


proc getCondaCommand(name: string): string =
    if isCondaEnvironmentFile(name):
        return &"conda env create -f {name}"

    &"conda create --name {name}"


proc createEnvironment*(name: string) =
    discard execShellCmd(get_conda_command(name))
