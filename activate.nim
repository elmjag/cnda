import strformat
from envs import getEnvs, lookupEnvironmentName


proc activateEnvironment*(name: string) =
    let envName = lookupEnvironmentName(name)
    echo &"conda activate {envName}"
