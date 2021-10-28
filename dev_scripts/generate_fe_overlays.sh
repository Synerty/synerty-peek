#!/bin/bash

function main () {
    cd ~/dev-peek

    echo "" > /tmp/_peek_fe_overlays_transcation.list

    # create transcation file list
    for d in *;
    do
        pushd $d > /dev/null

            gitRepoFolderName=$(basename $(git rev-parse --show-toplevel))
            git diff --name-only | \
            xargs -L1 -I{} echo $gitRepoFolderName/{} >> \
                /tmp/_peek_fe_overlays_transcation.list

        popd > /dev/null
    done

    # sync to folder frontendSrcOverlayDir
    pushd ~/dev-peek > /dev/null

        rsync -av --relative \
        --files-from /tmp/_peek_fe_overlays_transcation.list \
        . ~/peek-"$1"-service.home/frontendSrcOverlayDir

    popd  > /dev/null

    rm /tmp/_peek_fe_overlays_transcation.list

    # git reset changes
    for d in *;
    do
        pushd $d > /dev/null
            # stash changes with a name
            git stash push -m "$(date +'%Y-%m-%d_%H%M%S')"
            # set to HEAD
            git reset --hard HEAD
        popd > /dev/null
    done

}

function print_usage () {
    echo "copy changed source files to ~/peek-{field, office}-service
    .home/frontendSrcOverlayDir"
    echo ""
    echo Usage: $0 "<office|field>"
}


if [[ $# -ne 1 ]]; then
    print_usage
else

    if [[ $1 -eq "office" ]] || [[ $1 -eq "field" ]]; then
        main
    else
        print_usage
    fi
fi