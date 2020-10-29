#!/usr/bin/env bash

set -o nounset
set -o errexit

frontendDirs="
../peek-field-app/peek_field_app
../peek-office-app/peek_office_app
../peek-admin-app/peek_admin_app
"


for x in $frontendDirs; do
    (cd $x && npm "$@")
done

