#!/usr/bin/env bash

source ~/.bash_profile

set -o nounset
set -o errexit

wantedVer=${1-}
wantedVer=${wantedVer/v/}

if [ -n ${wantedVer} ]; then
    echo "Requested version is $wantedVer"
fi

platformReposDir=${2:-nodir}
platformPackagesDir=${3:-nodir}
startDir=${4:-`pwd`}
pinnedDepsPyFile=${5:-nofile}

baseDir="$startDir/peek_community_macos"

[ -d $baseDir ] && rm -rf $baseDir


# ------------------------------------------------------------------------------
# Download the peek platform and all it's dependencies

# Create the dir for the py wheels
mkdir -p $baseDir/py
cd $baseDir/py

pipWheelArgs=" --no-cache --find-links=${platformPackagesDir}"
if [ -f "${pinnedDepsPyFile}" ]; then
    echo "Using requirements file : ${pinnedDepsPyFile}"
    pipWheelArgs="-r ${pinnedDepsPyFile} $pipWheelArgs"
else
    echo "Requirements file is missing : ${pinnedDepsPyFile}"
fi

echo "Downloading and creating wheels"
if [ -n ${wantedVer} ]; then
    pip wheel synerty-peek==${wantedVer} $pipWheelArgs
else
    pip wheel synerty-peek $pipWheelArgs
fi

# Make sure we've downloaded the right version
peekPkgVer=`cd $baseDir/py && ls synerty_peek-* | cut -d'-' -f2`

if [ -n "${wantedVer}" -a "${wantedVer}" != "${peekPkgVer}" ]; then
   echo "We've downloaded version ${peekPkgVer}, but you wanted ver ${wantedVer}"
else
    echo "We've downloaded version ${peekPkgVer}"
fi

# These are installed as a dependency on macOS
# *     Shapely
# *     pymssql

# ------------------------------------------------------------------------------
# Compile nodejs for the release.
# This should be portable.

nodeDir="$baseDir/node"

cd $baseDir
nodeVer="12.18.3"

# Download the file
nodeFile="node-v${nodeVer}-darwin-x64.tar.gz"
curl -O "https://nodejs.org/dist/v${nodeVer}/node-v${nodeVer}-darwin-x64.tar.gz"

# Unzip it
gunzip -c ${nodeFile} | tar xopf -
mv node-v${nodeVer}-darwin-x64 ${nodeDir}

# Remove the downloaded file
rm -rf ${nodeFile}

# Move NODE into place

# Set the path for future NODE commands
PATH="$nodeDir/bin:$PATH"

# Install the required NPM packages
npm cache clean --force
npm -g install @angular/cli@^9.1.2 typescript@3.8.3 tslint

# ------------------------------------------------------------------------------
# This function downloads the node modules and prepares them for the release

function downloadNodeModules {
    # Get the variables for this package
    nmDir=$1

    packageJsonUrl="$2/package.json"
    packageLockJsonUrl="$2/package-lock.json"

    packageJsonDir="$3/package.json"
    packageLockJsonDir="$3/package-lock.json"

    # Create the tmp dir
    mkdir -p "$nmDir/tmp"
    cd "$nmDir/tmp"

    if [ -f ${packageJsonDir} ]
    then
        # Download package.json
        cp "$packageJsonDir" .

        cp "$packageLockJsonDir" .
    else
        # Download package.json
        curl -O "$packageJsonUrl" .

        curl -O "$packageLockJsonUrl" .
    fi

    # run npm install
    npm install

    # Move to where we want node_modules and delete the tmp dir
    # some packages create extra files that we don't want
    cd $nmDir
    mv tmp/node_modules .

    # Cleanup the temp dir
    rm -rf tmp
}

# FIELD node modules
mobilePackageVer=`cd $baseDir/py && ls peek_field_app-* | cut -d'-' -f2`
mobileBuildWebDIR="$baseDir/field-app"
mobileJsonUrl="https://bitbucket.org/synerty/peek-field-app/raw/${mobilePackageVer}/peek_field_app"
mobileJsonDir="${platformReposDir}/peek-field-app/peek_field_app"
downloadNodeModules $mobileBuildWebDIR $mobileJsonUrl $mobileJsonDir

# OFFICE node modules
desktopPackageVer=`cd $baseDir/py && ls peek_office_app-* | cut -d'-' -f2`
desktopBuildWebDIR="$baseDir/office-app"
desktopJsonUrl="https://bitbucket.org/synerty/peek-office-app/raw/${desktopPackageVer}/peek_office_app"
desktopJsonDir="${platformReposDir}/peek-office-app/peek_office_app"
downloadNodeModules $desktopBuildWebDIR $desktopJsonUrl $desktopJsonDir

# ADMIN node modules
adminPackageVer=`cd $baseDir/py && ls peek_admin_app-* | cut -d'-' -f2`
adminBuildWebDIR="$baseDir/admin-app"
adminJsonUrl="https://bitbucket.org/synerty/peek-admin-app/raw/${adminPackageVer}/peek_admin_app"
adminJsonDir="${platformReposDir}/peek-admin-app/peek_admin_app"
downloadNodeModules $adminBuildWebDIR $adminJsonUrl $adminJsonDir

# ------------------------------------------------------------------------------
# Copy over the init scripts for this platform

# mkdir $baseDir/init && pushd $baseDir/init

# for s in peek_logic_service peek_worker_service peek_agent_service peek_office_service peek_field_service
# do
#     cp ${platformReposDir}/synerty-peek/scripts/macos/init/${s}.service ${s}.service
# done
# popd

# ------------------------------------------------------------------------------
# Copy over the util scripts for this platform

# mkdir $baseDir/util && pushd $baseDir/util

# utilScripts="restart_peek.sh stop_peek.sh"
# for s in $utilScripts
# do
#     cp ${platformReposDir}/synerty-peek/scripts/linux/util/${s} ${s}
# done
# popd

# ------------------------------------------------------------------------------
# Set the location back to where we were.
cd $startDir

# Finally, version the directory
releaseDir="${baseDir}_${peekPkgVer}";
releaseZip="${releaseDir}.tar.bz2"
mv ${baseDir} ${releaseDir}


# Delete an old release zip if it exists
if [ -f ${releaseZip} ]; then
    rm ${releaseZip}
fi

# Create the zip file
echo "Compressing the release"
(cd ${releaseDir} && tar cjf ${releaseZip} *)

# Remove the working dir
rm -rf ${releaseDir}

# We're all done.
echo "Successfully created release ${peekPkgVer}";
echo "Located at ${releaseZip}";
