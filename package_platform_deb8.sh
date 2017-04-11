#!/usr/bin/env bash

source ~/.bashrc

set -o nounset
set -o errexit

wantedVer=${1-}

if [ -n ${wantedVer} ]; then
    echo "Requested version is $wantedVer"
fi

startDir=`pwd`

baseDir="$startDir/peek_dist_deb8"

[ -d $baseDir ] && rm -rf $baseDir


# ------------------------------------------------------------------------------
# Compile the python wheels for the linux distribution

pyDIR="$baseDir/py"
mkdir -p $pyDIR

cd $pyDIR
pip install wheel
pip wheel --no-cache synerty-peek

# The outer brackets convert it to an array
peekPkgVer=`ls synerty_peek-* | cut -d'-' -f1`

if [ -n ${wantedVer} -a ${wantedVer} -ne ${peekPkgVer} ]; then
   echo "We've downloaded version ${peekPkgVer}, but you wanted ver ${wantedVer}"
else
    echo "We've downloaded version ${peekPkgVer}"
fi

# Shapely is installed with the wheel command as dependency

# ------------------------------------------------------------------------------
# Compile nodejs for the release.
# This should be portable.

nodeDir="$baseDir/node"

#.  Download the supported node version ::
PEEK_NODE_VER="7.1.0"
mkdir $baseDir/node_src &&  cd $baseDir/node_src

wget "https://nodejs.org/dist/v${PEEK_NODE_VER}/node-v${PEEK_NODE_VER}-linux-x64.tar.xz"
tar xvJf node-v${PEEK_NODE_VER}-linux-x64.tar.xz
cd node-v${PEEK_NODE_VER}

#.  Configure the NodeJS Build ::

./configure --prefix=$nodeDir
make install

# Remove the src files
cd $baseDir
rm -rf node_src

# Set the path for future NODE commands
PATH="$nodeDir/bin:$PATH"

which node
echo "It should be $nodeDir/bin/node"

which npm
echo "It should be $nodeDir/bin/npm"

#.  Install the required NPM packages ::
npm -g upgrade npm
npm -g --prefix "$nodeDir" @angular/cli typescript tslint

# ------------------------------------------------------------------------------
# This function downloads the node modules and prepares them for the release

function downloadNodeModules {
    startDir=$1
    URL=$2

    mkdir -p "$startDir/tmp"

    cd "$startDir/tmp"
    wget "$URL"
    npm install
    cd ..
    mv tmp/node_modules .
    rm -rf tmp
}

# MOBILE node modules
mobileBuildWebDIR="$baseDir/mobile-build-web"
mobileJsonUrl='https://bitbucket.org/synerty/peek-mobile/raw/master/peek_mobile/build-web/package.json'
downloadNodeModules $mobileBuildWebDIR $mobileJsonUrl

# ADMIN node modules
adminBuildWebDIR="$baseDir/admin-build-web"
adminJsonUrl='https://bitbucket.org/synerty/peek-admin/raw/master/peek_admin/build-web/package.json'
downloadNodeModules $adminBuildWebDIR $adminJsonUrl

# ------------------------------------------------------------------------------
# Set the location back to where we were.
cd $startDir

# Finally, version the directory
releaseDir="${baseDir}_${peekPkgVer}";
releaseZip="${releaseDir}.tar.bz2"
mv ${baseDir} ${releaseDir}


# Create the zip file
echo "Compress the release"
tar cjf ${releaseZip} ${releaseDir}

# We're all done.
echo "Successfully created release ${peekPkgVer}";
echo "Located at ${releaseZip}";