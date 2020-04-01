#!/usr/bin/env bash

source ./pip_common.sh

VERSION=${1}
SRC_PATH="${2:-..}"
DST_PATH="${3:-/tmp/plugin}"

function updateFileVers {
    VER="${VER:-$1}"
    echo "Setting version to $VER"
    PIP_PACKAGE=${PY_PACKAGE//_/-} # Replace _ with -
    VER_FILES="${VER_FILES} setup.py"
    VER_FILES="${VER_FILES} ${PY_PACKAGE}/__init__.py"
    VER_FILES="${VER_FILES} ${PY_PACKAGE}/plugin_package.json"
    for file in ${VER_FILES}
    do
        if [ -f ${file} ]; then
            sed -i "s/^__version__.*/__version__ = \'${VER}\'/g" ${file}
            sed -i "s/###PEEKVER###/${VER}/g" ${file}
            sed -i "s/111.111.111/${VER}/g" ${file}
            sed -i "s/0.0.0/${VER}/g" ${file}
        fi
    done
}

function package_plugins() {
    for pkg in $PLUGINS; do
        pushd "${SRC_PATH}/${pkg}"
        if [ -f "setup.py" ]; then
            source publish.settings.sh
            updateFileVers ${VERSION}
            python setup.py sdist --format=gztar
        fi
        popd
    done
}

function package_platform() {
    for pkg in $PACKAGES; do
        pushd "${SRC_PATH}/${pkg}"
        if [ -f "setup.py" ]; then
            source publish.settings.sh
            updateFileVers ${VERSION}
            python setup.py sdist --format=gztar
        fi
        popd
    done
}

function extract_plugins() {
    pushd "${SRC_PATH}"
    mkdir -p ${DST_PATH}
    cp peek-plugin-*/dist/*${VERSION}.tar.gz ${DST_PATH}
    cp peek-core-user/dist/*${VERSION}.tar.gz ${DST_PATH}
    popd
    pushd ${DST_PATH}
    pip wheel --no-cache --find-links=. *.gz
    rm -f peek_*whl
    zip -r peek_linux_plugins_${VER}.zip .
    find . -type f ! -name "*.zip" -delete
    pwd
    ls
    popd
}

package_platform
package_plugins
extract_plugins
