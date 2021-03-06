import strformat
from envs import getEnvs, lookupEnvironmentName


proc removeEnvironment*(name: string) =
    let envName = lookupEnvironmentName(name)
    echo &"conda remove --name {envName} --all"
