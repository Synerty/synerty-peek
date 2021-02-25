#!/usr/bin/env bash
# list Peek repositories that are not in master branch with a count of unpushed
# commits of that branch

function getCurrentBranch() {
    # $1: git folder
    pushd $1 > /dev/null
    branch=$(git branch --show-current)
    if [[ $branch != "master" ]]
    then
        uncommitedCount=$(git rev-list --count origin/$branch..$branch --)
        untrackedfilesCount=$(git ls-files --others --exclude-standard | wc -l)
        changesCount=$(git diff --cached --numstat | wc -l)
        folderName=$(basename $1)
        echo "$folderName" \($branch\): $uncommitedCount unpushed commits, $untrackedfilesCount untracked files, $changesCount staged changes
    fi

    popd > /dev/null
}

for f in ~/dev-peek/*; do
    getCurrentBranch $f
done
