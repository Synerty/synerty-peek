#!/usr/bin/env bash

source ./pip_common.sh

# -------------------------------------
VER="${VER:-$1}" # If VER is not defined, try arg 1
[ "${VER}" == '${bamboo.jira.version}' ] && unset VER # = "0.0.0dev${BUILD}"
VER="${VER:?You must pass a version of the format 0.0.0 as the only argument}"


function convertBambooDate() {
# EG s="2010-01-01T01:00:00.000+01:00"
# TO 100101.0100
python <<EOF
from dateutil.parser import parse
print parse("${BAMBOO_DATE}").strftime('%y%m%d.%H%M')
EOF
}
#echo "start version is $VER"

#BUILD="${BUILD:-0}" # Default to build 0
#VER="${VER}"
if [ "${BAMBOO_DATE:-}" ]; then
    DATE="`convertBambooDate`"
else
    DATE="`date +%y%m%d.%H%M`"
fi

#echo "New version is $VER"
#echo "New build is $BUILD"

# -------------------------------------
echo "CHECKING for package existance"
EXIT=""
for pkg in $PACKAGES; do
    if [ ! -d "../$pkg" ]; then
        echo "${bold}${pkg}${normal} : ../$pkg does not exist" >&2
        EXIT="Y"
    fi
done
echo
[ -n "$EXIT" ] && exit 1

# -------------------------------------
echo "CHECKING for uncommitted changes"
EXIT=""
for pkg in $PACKAGES; do
    if [ -n "$(cd ../$pkg && git status --porcelain)" ]; then
        echo "${bold}${pkg}${normal} : has uncomitted changes, make sure all changes are comitted" >&2
        EXIT="Y"
    fi
done
echo
[ -n "$EXIT" ] && exit 1

# -------------------------------------
echo "CHECKING for existing tag"
EXIT=""
for pkg in $PACKAGES; do
    if (cd ../$pkg && git tag | grep -q "${VER}"); then
        echo "${bold}${pkg}${normal} : has an existing git tag for version ${VER}." >&2
        EXIT="Y"
    fi
done
echo
[ -n "$EXIT" ] && exit 1

# -------------------------------------
echo "CHECKING for successful build"
for pkg in $PACKAGES; do
    if ! (cd ../$pkg && python setup.py sdist --format=gztar); then
        echo "${bold}${pkg}${normal} : failed to build." >&2
        exit 1
    fi
done
echo

# -------------------------------------
echo "Building packages"
for pkg in $PACKAGES; do
    if ! (cd ../$pkg && bash ./publish.sh ${VER} ); then
        echo "${bold}${pkg}${normal} : failed to run publish." >&2
        exit 1
    fi
done
echo
