#!/usr/bin/env bash

package="${1:?you must enter the pacakge version}"
webOnly=${2-0}

frontendDirs="
../peek-mobile/peek_mobile/build-web
../peek-desktop/peek_desktop/build-web
../peek-admin/peek_admin/build-web
"

if [ ${webOnly} == 0 ]; then
    frontendDirs=" $frontendDirs ../peek-mobile/peek_mobile/build-ns"
fi

for x in $frontendDirs; do
    (cd $x && npm install --save $package)
done

