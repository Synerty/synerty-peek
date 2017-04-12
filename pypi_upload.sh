#!/usr/bin/env bash

source ./pip_common.sh

echo


# -------------------------------------
echo "Uploading to PYPI"
EXIT=""
for pkg in $PACKAGES; do
    # if ! (cd ../$pkg && rm -rf dist/* && python setup.py sdist && twine upload dist/*); then

    if ! (cd ../$pkg && python setup.py sdist upload -r pypi); then
        echo "${bold}${pkg}${normal} : Failed to build and upload to pypi" >&2
        exit 1
    fi
done
