#!/usr/bin/env bash

set -o nounset
set -o errexit

#------------------------------------------------------------------------------
# Prechecks

if ! [ -f "setup.py" ]; then
    echo "publish.sh must be run in the directory where setup.py is" >&2
    exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
    echo "There are uncommitted changes, please make sure all changes are committed" >&2
    exit 1
fi

VER="${1:?You must pass a version of the format 0.0.0 as the only argument}"

DEVBUILD=0
if echo ${VER} | grep -q '[[:alpha:]]'; then
  echo "This is a DEV build"
  DEVBUILD=1
fi

if git tag | grep -q "^${VER}$"; then
    echo "Git tag for version ${VER} already exists." >&2
    exit 1
fi

#------------------------------------------------------------------------------
# Configure package preferences here

source ./publish.settings.sh

PIP_PACKAGE=${PY_PACKAGE//_/-} # Replace _ with -

HAS_GIT=`ls -d .git 2> /dev/null`

#------------------------------------------------------------------------------
# Set the versions
echo "Setting version to $VER"

VER_FILES="${VER_FILES} setup.py"
VER_FILES="${VER_FILES} ${PY_PACKAGE}/__init__.py"
VER_FILES="${VER_FILES} ${PY_PACKAGE}/plugin_package.json"

function updateFileVers {
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

# Apply the version to the other files
updateFileVers

#------------------------------------------------------------------------------
# Clear out old files

rm -rf dist *.egg-info

#------------------------------------------------------------------------------
# Create the package and upload to pypi

python setup.py sdist --format=gztar

if [ ${PYPI_PUBLISH} == "1" -a ${DEVBUILD} -eq 0 ]; then
    echo "Publishing ${PIP_PACKAGE} to PyPI"
    twine upload dist/${PIP_PACKAGE}-${VER}.tar.gz
fi

#------------------------------------------------------------------------------
# Reset the commit, we don't want versions in the commit
# Tag and push this release
if [ $HAS_GIT ]; then
    # We need to commit the config file with the version for Read The Docs
    if [ -n "${VER_FILES_TO_COMMIT}"  -a ${DEVBUILD} -eq 0  ]; then
        git add ${VER_FILES_TO_COMMIT}
        git commit -m "Updated conf.py to ${VER}"
    fi

    git reset --hard

    if [ ${DEVBUILD} -eq 0 ]; then
      echo "Tagging ${PIP_PACKAGE}"
      git tag ${VER}

      echo "Pushing ${PIP_PACKAGE} to BitBucket"
      git push
      git push --tags
    fi

    if [ ${GITHUB_PUSH} == "1" -a ${DEVBUILD} -eq 0 ]
    then
        echo "Pushing ${PIP_PACKAGE} to GitHub"
        git remote remove github 2> /dev/null || true
        git remote add github git@github.com:Synerty/${PIP_PACKAGE}.git
        git push -f github master || true
    fi

fi


#------------------------------------------------------------------------------
# All done

echo "Publish Complete"
