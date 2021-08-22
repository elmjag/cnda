import strformat
from os import commandLineParams, findExe, parentDir, joinPath, moveFile, createDir, expandTilde
from strutils import replace
from tempfile import mkstemp


const BASH_HOOK_FILE_TEMPLATE = """#/usr/bin/env bash

complete -C CNDA_PATH cnda
cnda()
{
    _cnda_out="$(CNDA_PATH $@)"
    _cnda_exit_code=$?

    if [[ "$_cnda_exit_code" -ne 0 ]]; then
        echo "$_cnda_out"
        return
    fi

    $_cnda_out
}
"""


type
    CondaDirs = object
        condaBin: string
        shell: string


proc errorExit(message: string) =
    echo message
    quit(1)


proc parseArgs(): string =
    let args = commandLineParams()

    return args[0]


proc getCondaDirs(): CondaDirs =
    let condaExe = findExe("conda")
    if condaExe == "":
        errorExit(
            "No 'conda' binary found, can't install 'cnda' package.\n\n" &
            "Make sure 'miniconda' package is properly installed and that\n" &
            "the 'conda' binary directory is added to PATH environmet variable.")

    result.condaBin = parentDir(condaExe)
    result.shell = joinPath(parentDir(result.condaBin), "shell")


proc installCndaBinary(extractedDir: string, condaDirs: CondaDirs): string =
    let srcCndaBin = joinPath(extractedDir, "cnda")
    let dstCndaBin = joinPath(condaDirs.condaBin, "cnda")

    moveFile(srcCndaBin, dstCndaBin)

    return dstCndaBin


proc writeHookLines(file: File, hookLines: array[0..1, string]) =
    for line in hookLines:
        writeLine(file, line)


proc addHookToBashRc(hookPath: string) =
    #
    # Add 'cnda' hook lines to current user's .bashrc file.
    #
    # These lines will source the cnda hook shell file, and
    # make the 'cnda' utility, and it's autocompletions available.
    #
    let hookLines = [
        "# >>> cnda initialize >>>",
        &". {hookPath}"
    ]

    let bashRcPath = expandTilde("~/.bashrc")

    #
    # copy .bashrc to a temp file, line by line,
    # and add our hook lines after the end of conda init block
    #
    let (tempFd, tempFileName) = mkstemp(mode = fmWrite)
    var hookAdded = false
    for line in bashRcPath.lines:
        #
        # check if previous hook lines are present,
        # and don't write them, to avoid having duplicate
        # cnda init block in the .bashrc
        #
        if not(line in hookLines):
            writeLine(tempFd, line)

        if line == "# <<< conda initialize <<<":
            writeHookLines(tempFd, hookLines)
            hookAdded = true

    if not hookAdded:
        # tell user we failed to add hook lines to .bashrc
        errorExit(&"No 'conda' initializer found in '{bashRcPath}'.\n" &
                  "Failed to add 'cnda' initialize.")

    # overwrite the .bashrc with our temp file
    tempFd.close()
    moveFile(tempFileName, bashRcPath)


proc writeBashHookFile(hookPath, cndaBinPath: string) =
    let hookScript = replace(BASH_HOOK_FILE_TEMPLATE, "CNDA_PATH", cndaBinPath)
    writeFile(hookPath, hookScript)


proc installBashHook(condaDirs: CondaDirs, cndaBinPath: string) =
    let hookDir = joinPath(condaDirs.shell, "cnda")
    createDir(hookDir)

    let hookPath = joinPath(hookDir, "hook-bash.sh")
    writeBashHookFile(hookPath, cndaBinPath)
    addHookToBashRc(hookPath)


proc writeSuccessMsg(condaDirs: CondaDirs) =
    let condaRootDir = parentDir(condaDirs.condaBin)
    echo &"'cnda' utility added to conda installation in {condaRootDir}"


let extractedDir = parseArgs() # the temp directoy where files were extracted
let condaDirs = getCondaDirs()

let cndaBinPath = installCndaBinary(extractedDir, condaDirs)
installBashHook(condaDirs, cndaBinPath)

writeSuccessMsg(condaDirs)
