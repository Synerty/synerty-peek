#!/usr/bin/env bash

set -o nounset
set -o errexit

echo

PACKAGES="peek
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
if ! [ -f "setup.py" ]; then
    echo "setver.sh must be run in the directory where setup.py is" >&2
    exit 1
fi

# -------------------------------------
VER="${1:?You must pass a version of the format 0.0.0 as the only argument}"

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
# -------------------------------------
exit 0


echo "Setting version to $VER"

# Update the setup.py
sed -i "s;^package_version.*=.*;package_version = '${VER}';"  setup.py

# Upload to test pypi
python setup.py sdist upload -r pypitest

# Reset the commit, we don't want versions in the commit
git commit -a -m "Updated to version ${VER}"

git tag ${VER}
git push
git push --tags



echo "If you're happy with this you can now run :"
echo
echo "python setup.py sdist upload -r pypi"
echo