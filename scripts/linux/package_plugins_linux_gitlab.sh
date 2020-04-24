#!/usr/bin/env bash

source ~/.bashrc

set -o nounset
set -o errexit

source ./pip_common.sh

VER=${1}
SRC_PATH="${2:-..}"
SRC_PLATFORM_PATH="${3:-..}"
DST_PATH="${4:-/tmp/plugin}"


DIR_TO_TAR="peek_plugins_linux_${VER}"

# create and change to the directory we'll zip
cd ${DST_PATH}
mkdir ${DIR_TO_TAR} && cd ${DIR_TO_TAR}

# Copy over the plugins
cp ${SRC_PATH}/*.gz .

# Create the plugins release
pip wheel --no-cache --find-links=. --find-links=${SRC_PLATFORM_PATH} *.gz

# Delete all the wheels created for the plugins
rm -f peek-plugin*.gz

# Delete all the platform plugins that have been brought in
ls peek_*whl synerty_peek*whl | grep -v peek_plugin | xargs rm -f
rm peek_plugin_base*whl

# CD one directory back so we can tar the directory
cd ..

# Tar the directory
tar cjf ${DIR_TO_TAR}.tar.bz2 ${DIR_TO_TAR}

# Cleanup the directory we made
rm -rf ${DIR_TO_TAR}
