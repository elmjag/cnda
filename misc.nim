import strformat
from envs import getEnvs, lookupEnvironmentName

##
## Implementation of miscellaneous actions
##
##


proc activateEnvironment*(name: string) =
    let envName = lookupEnvironmentName(name)
    echo &"conda activate {envName}"


proc deactivateEnvironment*() =
    echo "conda deactivate"
