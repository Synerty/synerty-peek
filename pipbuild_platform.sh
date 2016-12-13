#!/usr/bin/env bash

set -o nounset
set -o errexit
# set -x

PACKAGES="synerty-peek
papp_base
peek_platform
peek_agent
peek_client
peek_client_fe
peek_server
peek_server_fe
peek_worker"

bold=$(tput bold)
normal=$(tput sgr0)

# -------------------------------------
VER="${VER:-$1}" # If VER is not defined, try arg 1
[ "${VER}" == '${bamboo.jira.version}' ] && unset VER # = "0.0.0dev${BUILD}"
VER="${VER:?You must pass a version of the format 0.0.0 as the only argument}"


# -------------------------------------
if ! [ -f "setup.py" ]; then
    echo "setver.sh must be run in the directory where setup.py is" >&2
    exit 1
fi

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
echo "CHECKING for for successful build"
for pkg in $PACKAGES; do
    if ! (cd ../$pkg && python setup.py sdist); then
        echo "${bold}${pkg}${normal} : failed to build." >&2
        exit 1
    fi
done
echo


## -------------------------------------
#echo "Building synerty-peek"
#./pipbuild.sh ${VER}

# -------------------------------------
echo "Building packages"
for pkg in $PACKAGES; do
    if ! (cd ../$pkg && ./pipbuild.sh ${VER} ); then
        echo "${bold}${pkg}${normal} : failed to run pipbuild." >&2
        exit 1
    fi
done
echo

RELEASE="dist/peek-release-${VER}"
RELEASE_TAR="peek-release-${VER}.tar.gz"

[ -d $RELEASE ] && rm -rf $RELEASE
[ -f dist/$RELEASE_TAR ] && rm dist/$RELEASE_TAR

mkdir -p $RELEASE
TAR_ARGS=""
for pkg in $PACKAGES; do
    cp ../${pkg}/dist/${pkg}-${VER}.tar.gz $RELEASE
done

echo "${DATE}" > $RELEASE/version

(cd $RELEASE &&  tar cvzf ../$RELEASE_TAR *)
[ -d $RELEASE ] && rm -rf $RELEASE

echo
echo "Peek Release compressed to dist/${RELEASE_TAR}"
echo

if [[ ${VER} != *"dev"* ]]; then
    echo "If you're happy with this you can now run :"
    echo "./pypi_upload.sh"
    echo
fi