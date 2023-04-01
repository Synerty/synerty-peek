#!/bin/bash

set -o nounset
set -o errexit

source ./pip_common.sh

HAS_PBZIP2=false

if ! [ -x "$(command -v pbzip2)" ]
    then
    echo 'pbzip2 is not installed, you may experience longer archiving time.'
    $HAS_PBZIP2=true
fi

function maybeParallelTarBzip2() {
    output=$1
    dirToTar=$2

    if [ $HAS_PBZIP2=true ]
    then
        tar --use-compress-prog=pbzip2 -cf $1 $2
    else
        tar cjf $1 $2
    fi
}

# ------------------------------------------------------------------------------
# This function downloads the node modules and prepares them for the release

function downloadNodeModules() {
    # Get the variables for this package
    nmDir="$1"

    packageJsonUrl="$2/package.json"
    packageLockJsonUrl="$2/package-lock.json"

    packageJsonDir="$3/package.json"
    packageLockJsonDir="$3/package-lock.json"

    packageJsonDirExists=false
    [[ -f "${packageJsonDir}" ]] && packageJsonDirExists=true

    # Create the tmp dir
    mkdir -p "$nmDir/tmp"
    cd "$nmDir/tmp"

    if [[ $packageJsonDirExists=true ]]
    then
        # Download package.json
        echo $packageJsonDir
        cp "$packageJsonDir" .

        cp "$packageLockJsonDir" .
    else
        # Download package.json
        # TODO: access token to download stuff in enterprise group
        curl -O "$packageJsonUrl"

        curl -O "$packageLockJsonUrl"
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

function setUpNpm {

    baseDir=$1 # COMMUNITY_PACKAGE folder

    nodeDir="$baseDir/node"

    pushd $baseDir
    nodeVer="14.15.3"

    # Download the file
    nodeFile="node-v${nodeVer}-linux-x64.tar.xz"
    wget -nv "https://nodejs.org/dist/v${nodeVer}/node-v${nodeVer}-linux-x64.tar.xz"

    # Unzip it
    tar xJf ${nodeFile}
    mv node-v${nodeVer}-linux-x64 ${nodeDir}

    # Remove the downloaded file
    rm -rf ${nodeFile}

    # Move NODE into place

    # Set the path for future NODE commands
    PATH="$nodeDir/bin:$PATH"

    # Install the required NPM packages
    npm cache clean --force
    npm -g install @angular/cli@^10.2.0 typescript@4.0.3 tslint

    popd
}

function cacheEdnarNodeModules {
    # EDNAR peek node modules

    # decompress source code of the repo
    curDir=$(pwd)
    mkdir -p _ednar_tmp
    for file in peek-plugin-zepben-ednar-dms-diagram*.gz
    do
        tar -xvf $file -C _ednar_tmp
    done

    # download node modules to ednar-peek-app in the folder to be archived into
    #  peek_enterprise_linux_x.y.z-b12345.tar.bz2
    for folder in _ednar_tmp/peek-plugin-zepben-ednar-dms-diagram*
    do
        ednarPeekBuildWebDIR=$curDir"/ednar-peek-app"
        mkdir -p $ednarPeekBuildWebDIR
        ednarPeekJsonUrl="https://gitlab.synerty.com/peek/enterprise/peek-plugin-zepben-ednar-dms-diagram/-/raw/"${CI_COMMIT_REF_NAME}"/peek_plugin_zepben_ednar_dms_diagram/_private/office-app"
        ednarPeekJsonDir=$folder"/peek_plugin_zepben_ednar_dms_diagram/_private/office-app"
        ednarPeekJsonDir=$(realpath "$ednarPeekJsonDir")

        pushd $ednarPeekBuildWebDIR
        downloadNodeModules $ednarPeekBuildWebDIR $ednarPeekJsonUrl $ednarPeekJsonDir
        popd
    done

    # clean up temporary folders
    rm -rf _ednar_tmp

}

function packageCICommunity() {

    wantedVer=${1-}
    wantedVer=${wantedVer/v/}

    if [ -n "${wantedVer}" ]
    then
        echo "Requested version is $wantedVer"
    fi

    platformReposDir=${2:-nodir}
    platformPackagesDir=${3:-nodir}
    startDir=${4:-$(pwd)}
    pinnedDepsPyFile=${5:-nofile}

    baseDir="$startDir/peek_community_linux"

    [ -d $baseDir ] && rm -rf $baseDir

    # ------------------------------------------------------------------------------
    # Download the peek platform and all it's dependencies

    # Create the dir for the py wheels of Peek platform
    mkdir -p $baseDir/platform
    cd $baseDir/platform

    pipWheelArgs="--no-cache --find-links=${platformPackagesDir}"
    if [ -f "${pinnedDepsPyFile}" ]
    then
        echo "Using requirements file : ${pinnedDepsPyFile}"
        pipWheelArgs="-r ${pinnedDepsPyFile} $pipWheelArgs"
    else
        echo "Requirements file is missing : ${pinnedDepsPyFile}"
    fi

    echo "Downloading and creating wheels"
    if [ -n "${wantedVer}" ]
    then
        pip wheel synerty-peek==${wantedVer} $pipWheelArgs
    else
        pip wheel synerty-peek $pipWheelArgs
    fi

    # Make sure we've downloaded the right version
    peekPkgVer=$(cd $baseDir/platform && ls synerty_peek-* | cut -d'-' -f2)

    if [ -n "${wantedVer}" -a "${wantedVer}" != "${peekPkgVer}" ]
    then
        echo "We've downloaded version ${peekPkgVer}, but you wanted ver ${wantedVer}"
    else
        echo "We've downloaded version ${peekPkgVer}"
    fi

    # ------------------------------------------------------------------------------
    # Create the dir for the py wheels of Peek community plugins
    mkdir -p $baseDir/plugins
    cd $baseDir/plugins

    pipWheelArgs="--find-links=${platformPackagesDir}"
    if [ -f "${pinnedDepsPyFile}" ]
    then
        echo "Using requirements file : ${pinnedDepsPyFile}"
        pipWheelArgs="-r ${pinnedDepsPyFile} $pipWheelArgs"
    else
        echo "Requirements file is missing : ${pinnedDepsPyFile}"
    fi

    # Create the plugins release
    # Copy over the community plugins
    communityPls=""
    for plugin in ${COMMUNITY_PLUGINS}
    do
        communityPls="${communityPls} `echo ${platformPackagesDir}/${plugin}*.gz`"
    done
    pip wheel ${pipWheelArgs} ${communityPls}

    # Delete all the wheels created for the plugins
    rm -f *.gz

    # These are installed as a dependency on Linux
    # *     Shapely
    # *     pymssql

    # ------------------------------------------------------------------------------
    # Compile nodejs for the release.
    # This should be portable.

    setUpNpm $baseDir

    pushd $baseDir/platform
    # FIELD node modules
    mobilePackageVer=$(ls peek_field_app-* | cut -d'-' -f2)
    mobileBuildWebDIR=$baseDir"/field-app"
    mobileJsonUrl="https://gitlab.synerty.com/peek/community/peek-field-app/-/raw/${CI_COMMIT_REF_NAME}/peek_field_app"
    mobileJsonDir="${platformReposDir}/peek-field-app/peek_field_app"
    downloadNodeModules $mobileBuildWebDIR $mobileJsonUrl $mobileJsonDir
    popd
    
    pushd $baseDir/platform
    # OFFICE node modules
    desktopPackageVer=$(ls peek_office_app-* | cut -d'-' -f2)
    desktopBuildWebDIR=$baseDir"/office-app"
    desktopJsonUrl="https://gitlab.synerty.com/peek/community/peek-office-app/-/raw/${CI_COMMIT_REF_NAME}/peek_office_app"
    desktopJsonDir="${platformReposDir}/peek-office-app/peek_office_app"
    downloadNodeModules $desktopBuildWebDIR $desktopJsonUrl $desktopJsonDir
    popd

    pushd $baseDir/platform
    # ADMIN node modules
    adminPackageVer=$(ls peek_admin_app-* | cut -d'-' -f2)
    adminBuildWebDIR=$baseDir"/admin-app"
    adminJsonUrl="https://gitlab.synerty.com/peek/community/peek-admin-app/-/raw/${CI_COMMIT_REF_NAME}/peek_admin_app"
    adminJsonDir="${platformReposDir}/peek-admin-app/peek_admin_app"
    downloadNodeModules $adminBuildWebDIR $adminJsonUrl $adminJsonDir
    popd

    # ------------------------------------------------------------------------------
    # Copy over the init scripts for this platform

    mkdir $baseDir/init && pushd $baseDir/init

    for s in peek_logic peek_worker peek_office peek_field peek_agent
    do
        cp ${platformReposDir}/synerty-peek/scripts/linux/init/${s}.service ${s}.service
    done
    popd

    # ------------------------------------------------------------------------------
    # Copy over the util scripts for this platform

    mkdir $baseDir/util && pushd $baseDir/util

    utilScripts="p_restart.sh p_stop.sh p_watch.sh p_cat_queues.sh"
    for s in $utilScripts;
    do
        cp ${platformReposDir}/synerty-peek/scripts/linux/util/${s} ${s}
    done

    cp -p p_restart.sh restart_peek.sh
    cp -p p_stop.sh stop_peek.sh

    popd

    # ------------------------------------------------------------------------------
    # Set the location back to where we were.
    cd $startDir

    # Finally, version the directory
    releaseDir="${baseDir}_${peekPkgVer}"
    releaseZip="${releaseDir}.tar.bz2"
    mv ${baseDir} ${releaseDir}

    # Delete an old release zip if it exists
    if [ -f ${releaseZip} ]
    then
        rm ${releaseZip}
    fi

    # Create the zip file
    echo "Compressing the release"
    cd ${releaseDir} && maybeParallelTarBzip2 ${releaseZip} .

    # Remove the working dir
    rm -rf ${releaseDir}

    # We're all done.
    echo "Successfully created release ${peekPkgVer}"
    echo "Located at ${releaseZip}"

}

function packageCIEnterprisePlugins() {

    VER=${1}
    SRC_PATH="${2:-..}"
    COMMUNITY_PACKAGEs="${3:-..}"
    DST_PATH="${4:-/tmp/plugin}"
    pinnedDepsPyFile="${5:-nofile}"

    DIR_TO_TAR="peek_enterprise_linux_${VER}"

    # create and change to the directory we'll zip
    cd ${DST_PATH}
    mkdir ${DIR_TO_TAR} && cd ${DIR_TO_TAR}

    # Copy over the plugins
    cp ${SRC_PATH}/*.gz .

    setUpNpm $COMMUNITY_PACKAGEs

    cacheEdnarNodeModules

    pipWheelArgs="--no-cache --find-links=. --find-links=${COMMUNITY_PACKAGEs}"
    if [ -f "${pinnedDepsPyFile}" ]
    then
        echo "Using requirements file : ${pinnedDepsPyFile}"
        pipWheelArgs="-r ${pinnedDepsPyFile} $pipWheelArgs"
    else
        echo "Requirements file is missing : ${pinnedDepsPyFile}"
    fi

    # Create the plugins release
    pip wheel ${pipWheelArgs} *.gz

    # Delete all the wheels created for the plugins
    rm -f peek-plugin*.gz

    # Delete all the platform plugins that have been brought in
    ls peek_*whl synerty_peek*whl | grep -v peek_plugin | xargs rm -f
    rm peek_plugin_base*whl

    # CD one directory back so we can tar the directory
    cd ..

    # Tar the directory
    maybeParallelTarBzip2 ${DIR_TO_TAR}.tar.bz2 ${DIR_TO_TAR}

    # Cleanup the directory we made
    rm -rf ${DIR_TO_TAR}

}

function printUsageAndExit() {
    echo "Invalid arguments"
    echo "Usage: $0 -r <community|enterprise|ota> [args]"
    exit 1
}

function packageOnGitLabCI() {
    if [ "${release}" == "community" ]
    then
        # TODO: check arguments before invoke
        #  ./scripts/linux/package_linux.sh: line 18: 2: unbound variable
        #  https://gitlab.synerty.com/louis-lu/peek/community/synerty-peek/-/jobs/14581
        packageCICommunity $1 $2 $3 $4 $5
    elif [ "${release}" == "enterprise" ]
    then
        # TODO: check arguments before invoke
        packageCIEnterprisePlugins $1 $2 $3 $4 $5
    else
        printUsageAndExit
    fi
}

# main
platform=""
release=""
while getopts ":r:" o
do
    case "${o}" in
    r)
        release=${OPTARG}
        ;;
    *)
        printUsageAndExit
        ;;
    esac
done

#After getopts is done, shift all processed options away with
shift $((OPTIND - 1))

case "${release}" in
community | enterprise)
    packageOnGitLabCI $*
    ;;
*)
    printUsageAndExit
    ;;
esac
