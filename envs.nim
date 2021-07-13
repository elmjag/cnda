from os import findExe, parentDir, joinPath, walkDir, splitPath, PathComponent
from streams import newFileStream
import yaml/dom
from yaml/parser import YamlParserError

type
    InvalidEnvironmentFile* = object of CatchableError

iterator getEnvs*(): string =
    ##
    ## names of all available conda environments
    ##
    let condaDir = parentDir(parentDir(findExe("conda")))
    let envsDir = joinPath(condaDir, "envs")

    for kind, path in walkDir(envsDir):
        if kind != pcDir:
            # skip all non-directory entries
            continue

        let parts = splitPath(path)
        yield parts.tail


proc getEnvironmentName*(yamlFile: string): string =
    ##
    ## parse conda environment yaml file and
    ## get the name of the environment defined in file
    ##
    try:
        let doc = loadDom(newFileStream(yaml_file))
        return doc.root["name"].content
    except YamlParserError:
        raise newException(InvalidEnvironmentFile, "yaml parse error")
    except KeyError:
        raise newException(InvalidEnvironmentFile, "'name' element not found")


proc environmentExists*(envName: string): bool =
    ##
    ## returns true if environment with specified name exist
    ##
    for env in getEnvs():
        if env == envName:
            return true

    false


proc lookupEnvironmentName*(name: string): string =
    ##
    ## if 'name' specifies an existing environment, return 'name'
    ## otherwise, assume 'name' is a conda environment yaml file,
    ## and return environment name specified in that file
    ##
    if environmentExists(name):
        return name

    # TODO: check if file 'name' exists

    return envs.getEnvironmentName(name)
