import strformat
from os import execShellCmd
from envs import getEnvs, getEnvironmentName


proc environmentExists(envName: string): bool =
    for env in getEnvs():
        if env == envName:
            return true

    false


proc getEnvironmentName(name: string): string =
    if environmentExists(name):
        return name

    # TODO: check if file 'name' exists

    return envs.getEnvironmentName(name)


proc removeEnvironment*(name: string) =
    let envName = getEnvironmentName(name)
    discard execShellCmd(&"conda remove --name {envName} --all")
