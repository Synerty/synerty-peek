#!/usr/bin/env bash

set -o nounset
set -o errexit

frontendDirs="
../peek-mobile/peek_mobile
../peek-desktop/peek_desktop
../peek-admin/peek_admin
"


for x in $frontendDirs; do
    (cd $x && npm "$@")
done

