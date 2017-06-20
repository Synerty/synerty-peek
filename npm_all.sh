#!/usr/bin/env bash

set -o nounset
set -o errexit

frontendDirs="
../peek-mobile/peek_mobile/build-web
../peek-desktop/peek_desktop/build-web
../peek-admin/peek_admin/build-web
../peek-mobile/peek_mobile/build-ns
"


for x in $frontendDirs; do
    (cd $x && npm "$@")
done

