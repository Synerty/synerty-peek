=====================
Develop Peek Platform
=====================

.. WARNING:: This document extends, *Setup OS Requirements Windows* or the *Setup OS
    Requirements Debian* depending on your OS.

Most development will be for the plugins, not platform, so these instructions are not
high priority.

Development Setup Objective
---------------------------

This guide lists the synerty-peek repositories that can be cloned and how to clone.  The
document contains instructions for obtaining the dependencies, building the front end
packages and Building synerty-peek for development or production.

There is assumed understanding of *git*, forking and committing.

Hardware Recommendation
-----------------------

*  32gb of ram (minimum 16gb)

Software Installation and Configuration
---------------------------------------

On a Windows machine the follow commands will be run using the bash shell, see
:ref:`setup_msys_git`.

synerty-peek Repositories
`````````````````````````

:Synerty's Repositories: `<https://github.com/Synerty>`_

*  synerty-peek

*  peek-plugin-base

*  peek-agent

*  peek-client

*  peek-client-fe

*  peek-platform

*  peek-server

*  peek-server-fe

*  peek-worker

Clone Peek Repositories
```````````````````````

Checkout repositories all in the same folder

Use this script to insert individual peek modules.  Update {gitAccount} and
{repository} in the script below: ::

        GIT="{gitAccount}"
        REPO="{repository}"

        if [ ! -d ~peek/Documents/peek-dev ]; then
            mkdir ~peek/Documents/peek-dev
            cd ~peek/Documents/peek-dev/
            git clone https://github.com/$GIT/$REPO.git
            cd ~peek/Documents/peek-mobile/$REPO
            git config --unset core.symlink
            git config --add core.symlink true
        else
            echo "ALERT: `pwd` directory already exists.  Please investigate then retry."
        fi

        cd ~peek/Documents/peek-dev/
        ls -l

Use this script to clone all repositories.  Update {gitAccount} in the script below: ::

        GIT="{gitAccount}"

        REPOS="synerty-peek"
        REPOS="$REPOS peek-plugin-base"
        REPOS="$REPOS peek-agent"
        REPOS="$REPOS peek-client"
        REPOS="$REPOS peek-client-fe"
        REPOS="$REPOS peek-platform"
        REPOS="$REPOS peek-server"
        REPOS="$REPOS peek-server-fe"
        REPOS="$REPOS peek-worker"

        if [ ! -d ~peek/Documents/peek-dev ]; then
        mkdir ~peek/Documents/peek-dev
        cd ~peek/Documents/peek-dev/
        for REPO in ${REPOS[*]}
        do
            echo $REPO
            git clone https://github.com/$GIT/$REPO.git
            cd ~peek/Documents/peek-dev/$REPO
            git config --unset core.symlink
            git config --add core.symlink true
            cd ~peek/Documents/peek-dev/
        done
        else
            cd ~peek/Documents/peek-dev/
            echo "ALERT: `pwd` directory already exists.  Please investigate then retry."
        fi
        ls -l

.. NOTE:: core.symlink:  If false, symbolic links are checked out as small plain files
    that contain the link text.  The default is true, except *git-clone* or *git-init*
    will probe and set core.symlinks false if appropriate when the repository is created.

Install Front End Modules
`````````````````````````

Remove the old npm modules files and re-install for both client and server front and
packages.  Run the following commands: ::

        cd ~peek/Documents/peek-dev/peek-client-fe/peek_client_fe/build-web
        [ -d node_modules ] && rm -rf node_modules
        npm install
        cd ~peek/Documents/peek-dev/peek-client-fe/peek_client_fe/build-ns
        [ -d node_modules ] && rm -rf node_modules
        npm install
        cd ~peek/Documents/peek-dev/peek-server-fe/peek_server_fe/build-web
        [ -d node_modules ] && rm -rf node_modules
        npm install

Install synerty-peek Dependencies
`````````````````````````````````

These steps link the projects under site-packages and installs their dependencies.

For synerty-peek, run the following commands: ::

        cd ~peek/Documents/peek-dev/synerty-peek
        ./pip_uninstall_and_develop.sh

For repositories and plugins, run from their directory ::

            python setup.py develop

Compile Front End Packages
``````````````````````````

Symlink the tsconfig.json and node_modules file and directory in the parent directory
of peek-client-fe, peek-server-fe and the plugins. These steps are run in the directory
where the projects are checked out from. These are required for the frontend typescript
compiler.

Run the following commands: ::

        cd ~peek/Documents/peek-dev/peek-client-fe/peek_client_fe/build-web
        ng build
        cd ~peek/Documents/peek-dev/peek-server-fe/peek_server_fe/build-web
        ng build

