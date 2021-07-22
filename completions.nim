import strformat
from strutils import startsWith, toLowerAscii
from tables import keys, hasKey
from args import actionDescriptions
from os import walkFiles, splitPath, splitFile, getCurrentDir
from envs import validEnvironmentFile, getEnvs

type
    Suggestions = iterator (): string


proc empty(): Suggestions =
    ##
    ## returns an 'empty' iterator,
    ## used when we don't have any completions to suggest
    ##
    result = iterator (): string =
        return


proc concat(suggestion1, suggestion2: Suggestions): Suggestions =
    ##
    ## concatenate two Suggestions iterators into one
    ##
    return iterator (): string =
        for suggestion in [suggestion1, suggestion2]:
            for val in suggestion():
                yield val


proc isValidAction(argument: string): bool =
    return actionDescriptions.hasKey(argument)


proc isYamlExtention(filePath: string): bool =
    var (_, _, ext) = splitFile(filePath)
    ext = toLowerAscii(ext)

    return ext == ".yml" or ext == ".yaml"


proc matchingEnvFiles(prefix: string): Suggestions =
    return iterator (): string =
        # all matching conda environment files
        for filePath in walkFiles(&"{getCurrentDir()}/{prefix}*"):
            let (_, fileName) = splitPath(filePath)

            if not fileName.startsWith(prefix):
                continue

            if not isYamlExtention(fileName):
                continue

            if not validEnvironmentFile(filePath):
                continue

            yield fileName


proc matchingEnvironments(prefix: string): Suggestions =
    return iterator (): string =
        for env in getEnvs():
            if env.startsWith(prefix):
                yield env


proc getActionSuggestions(current: string): Suggestions =
    return iterator (): string =
        for action in actionDescriptions.keys:
            if startsWith(action, current):
                yield action


proc getRemoveActivateSuggestions(prefix: string): Suggestions =
    return concat(matchingEnvFiles(prefix), matchingEnvironments(prefix))


proc getActionArgsSuggestions(action, argumentPrefix: string): Suggestions =
    case action
    of "activate", "remove":
        return getRemoveActivateSuggestions(argumentPrefix)
    of "create":
        return matchingEnvFiles(argumentPrefix)

    return empty()


proc getSuggestions(previous, current: string): Suggestions =
    if previous == "cnda":
        return getActionSuggestions(current)
    if isValidAction(previous):
        return getActionArgsSuggestions(previous, current)

    return empty()


proc echoCompletions*(previous, current: string) =
    let suggestions = getSuggestions(previous, current)
    for suggestion in suggestions():
        echo suggestion

    # signal that completion suggestions list should be printed
    quit(1)
