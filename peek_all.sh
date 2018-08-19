#!/usr/bin/env bash

set -o nounset
set -o errexit

RED='\033[0;31m'
NC='\033[0m' # No Color


if [ -z ${1} ]
then
echo -e "
Running with no arguments produces this help

For example, to setup all plugins and packages for development, run this:
# ${RED}bash ./peek_all.sh python setup.py develop{NC}

"
exit 0
fi


if ! [ -f './git_all.sh' ] ;
then
    echo "git_all.sh must be run from the directory it lives in"
    exit 1
fi

# -------------------------------------
for pkgDir in $PACKAGES $PLUGINS; do
    echo "Running in ${pkgDir}: " "$@"
    (cd $pkgDir && "$@")
done
