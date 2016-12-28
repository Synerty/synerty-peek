#!/usr/bin/env bash
PACKAGE="peek"

set -o nounset # Error on unset variables
set -o errexit # Exit if a command fails

echo "Retrieving latest version tag"
VER=$(git describe --tags `git rev-list --tags --max-count=1`)

echo "Setting version to $VER"
sed -i "s;.*version.*;__version__ = '${VER}';" ${PACKAGE}/__init__.py

echo "==========================================="
echo "Building Sphinx documentation for '${PACKAGE}'!"
echo "==========================================="

echo "Removing old documentation in build folder..."
rm -fr dist/docs/*

echo "Creating link to the packages..."
rm -fr peek_agent peek_client peek_platform peek_server peek_worker
ln -s ../peek-agent/peek_agent/
ln -s ../peek-client/peek_client/
ln -s ../peek-platform/peek_platform/
ln -s ../peek-server/peek_server/
ln -s ../peek-worker/peek_worker/

echo "Creating Python Path"
source ./pip_common.sh
PYTHONPATH=""

for pkg in $PACKAGES; do
    PYTHONPATH="${PYTHONPATH}:`pwd`/../${pkg}"
done
export PYTHONPATH

echo "Ensure Sphinx and the theme that Synerty uses is installed..."
for pkg in sphinx sphinx_rtd_theme; do
    if ! pip freeze | grep -q "${pkg}==" ; then
        echo "Installing ${pkg}"
        pip install ${pkg}
    fi
done

echo "Running Sphinx-apidoc"
sphinx-apidoc -f -l -d 6 -o docs . '*Test.py' 'setup.py'

sphinx-build -b html docs dist/docs

echo "Removing old module rst files..."
rm -fr docs/peek* docs/modules.rst

echo "Cleaning up links..."
rm -fr peek_agent peek_client peek_platform peek_server peek_worker

echo "Opening created documentation..."
start dist/docs/index.html