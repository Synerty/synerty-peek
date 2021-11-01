#!/bin/bash

function main () {

    # create transcation file list
    for d in ~/dev-peek/*;
    do
        pushd $d > /dev/null

            rm -f /tmp/_peek_fe_overlays_transcation.list
            touch /tmp/_peek_fe_overlays_transcation.list

            if [[ $1 == "field" ]]; then
                echo sync for Field overlays not implemented
                exit 1
            fi

            if [[ $1 == "office" ]]; then

                gitRepoFolderName=$(basename $(git rev-parse --show-toplevel))
                gitRepoFolderNameUnderScore=${gitRepoFolderName//-/_}
                bothAppFolder="$d"/"$gitRepoFolderNameUnderScore"/_private/both-app

                if [[ -d $bothAppFolder ]]; then

                    # e.g. peek-office-service
                    # .home/frontendSrcOverlayDir/peek_plugin_enmac_switching
                    dstBaseFolder=~/peek-"$1"-service.home/frontendSrcOverlayDir/$gitRepoFolderNameUnderScore


                    git -C $bothAppFolder diff --name-only --relative | \
                        xargs -L1 -I{} echo {} >> \
                            /tmp/_peek_fe_overlays_transcation.list

                    [[ ! -s /tmp/_peek_fe_overlays_transcation.list ]] && \
                        continue

                    echo =============== Detect ===============
                    echo In Plugin $gitRepoFolderName
                    echo FROM: $bothAppFolder
                    echo TO: $dstBaseFolder
                    echo Transcation list:
                    cat /tmp/_peek_fe_overlays_transcation.list
                    echo ""

                    # Keep trailing '/' of $bothAppFolder
                    echo =============== Sync =================
                    rsync -av --delete\
                        --files-from /tmp/_peek_fe_overlays_transcation.list \
                        $bothAppFolder/ $dstBaseFolder
                    echo ""
                fi
            fi

            # if sync'd, git stash current changes and git reset to HEAD
            if [[ -s /tmp/_peek_fe_overlays_transcation.list ]]; then
                echo '=========== Backup & Restore ==========='
                # stash changes with a name
                git stash push -m "$(date +'%Y-%m-%d_%H%M%S')"
                # set to HEAD
                git reset --hard HEAD
                echo ""
            fi

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
        main $1
    else
        print_usage
    fi
fi