#!/usr/bin/env bash

if [ -z ${1} ]
then
echo <<EOF
Running with no arguments produces this help

To create and switch to a new peek branch:
# bash ./git_all.sh checkout -b v1.1.x

To push a new branch and set the upstream:
# bash ./git_all.sh push -u origin v1.1.x

To switch branches
# bash ./git_all.sh checkout master

To merge branch v1.1.x into master
# bash ./git_all.sh checkout master
# bash ./git_all.sh merge v1.1.x


EOF
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
