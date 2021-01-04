#!/usr/bin/env bash

source ./pip_common.sh
set errexit
set nounset

#
# TODO: Add support for creating merge requests as required.
#
# https://docs.gitlab.com/ee/api/merge_requests.html#create-mr
#
#curl --location --request POST 'https://gitlab.synerty.com/api/v4/projects/:id/merge_requests' \
#--header 'Authorization: Bearer YOURTOKEN' \
#--header 'Content-Type: application/json' \
#--data-raw '{
#	"id": 0,
#	"source_branch": "develop",
#	"target_branch": "master",
#	"title": "Title of MR",
#	"assignee_id": 0
#}'

# -------------------------------------
for pkgDir in $(ls -d ../peek-*) ../synerty-peek; do
    pushd $pkgDir >/dev/null

    branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$(git rev-parse $branch)" != "$(git rev-parse master)" ]; then
        echo "${pkgDir} needs a merge request" >&2
    fi

    popd >/dev/null

done
