#!/usr/bin/env bash


RED='\033[0;31m'
NC='\033[0m' # No Color


if [ -z ${1} ]
then
echo -e "
Running with no arguments produces this help

To create and switch to a new peek branch:
# ${RED}bash ./git_all.sh checkout -b v1.1.x${NC}

To push a new branch and set the upstream:
# ${RED}bash ./git_all.sh push -u origin v1.1.x${NC}

To switch branches
# ${RED}bash ./git_all.sh checkout master${NC}

To merge branch v1.1.x into master
# ${RED}bash ./git_all.sh checkout master${NC}
# ${RED}bash ./git_all.sh merge v1.1.x${NC}
"
exit 0
fi


if ! [ -f './git_all.sh' ] ;
then
    echo "git_all.sh must be run from the directory it lives in"
    exit 1
fi

# -------------------------------------
for pkgDir in `ls -d ../peek-*` ../synerty-peek; do
    echo "Running in ${pkgDir}: git " "$@"
    (cd $pkgDir && git "$@")
done
