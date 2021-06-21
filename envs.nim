from os import findExe, parentDir, joinPath, walkDir, splitPath, PathComponent


iterator get_envs*(): string =
    let conda_dir = parentDir(parentDir(findExe("conda")))
    let envs_dir = joinPath(conda_dir, "envs")

    for kind, path in walkDir(envs_dir):
        if kind != pcDir:
            # skip all non-directory entries
            continue

        let parts = splitPath(path)
        yield parts.tail
