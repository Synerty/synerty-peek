#!/usr/bin/env bash

set -o nounset
set -o errexit

source ./pip_common.sh

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
for PKG_NAME in $PLATFORM_PKGS $PLUGIN_PKGS; do
    echo "Running in ${PKG_NAME}: " "$@"
    (cd ../${PKG_NAME} && "$@")
done
