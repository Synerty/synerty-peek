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

On a Windows machine the follow commands will be run in the Cygwin terminal.

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

        cd ~peek/Documents/
        mkdir peek-mobile
        cd ~peek/Documents/peek-mobile/
        git clone https://github.com/$GIT/$REPO.git
        cd ~peek/Documents/peek-mobile/$REPO
        git config --unset core.symlink
        git config --add core.symlink true

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
        cd ~peek/Documents/
        mkdir ~peek/Documents/peek-mobile
        for REPO in ${REPOS[*]}
        do
            echo $REPO
            cd ~peek/Documents/peek-mobile/
            git clone https://github.com/$GIT/$REPO.git
            cd ~peek/Documents/peek-mobile/$REPO
            git config --unset core.symlink
            git config --add core.symlink true
        done
        cd ~peek/Documents/peek-mobile/
        ls -l

.. NOTE:: core.symlink:  If false, symbolic links are checked out as small plain files
    that contain the link text.  The default is true, except *git-clone* or *git-init*
    will probe and set core.symlinks false if appropriate when the repository is created.

Install Front End Modules
`````````````````````````

Remove the old npm modules files and re-install for both client and server front and
packages.  Run the following commands: ::

        cd ~peek/Documents/peek-mobile/peek-client-fe/peek_client_fe/
        [ -d node_modules ] && rm -rf node_modules
        npm install
        cd ~peek/Documents/peek-mobile/peek-server-fe/peek_server_fe/
        [ -d node_modules ] && rm -rf node_modules
        npm install

Compile Front End Packages
``````````````````````````

Symlink the tsconfig.json and node_modules file and directory in the parent directory
of peek-client-fe, peek-server-fe and the plugins. These steps are run in the directory
where the projects are checked out from. These are required for the frontend typescript
compiler.

Run the following commands: ::

        cd ~peek/Documents/peek-mobile/
        ln -s peek-client-fe/peek_client_fe/node_modules .
        ln -s peek-client-fe/peek_client_fe/tsconfig.json .

        cd ~peek/Documents/peek-mobile/peek-client-fe/peek_client_fe/
        ng build
        cd ~peek/Documents/peek-mobile/peek-server-fe/peek_server_fe/
        ng build

Install synerty-peek Dependencies
`````````````````````````````````

These steps link the projects under site-packages and installs their dependencies.

For synerty-peek, run the following commands: ::

        cd ~peek/Documents/peek-mobile/synerty-peek
        ./pip_uninstall_and_develop.sh

For repositories and plugins, run from their directory ::

            python setup.py develop

.. NOTE:: For offline installation, copy across the software to the offline server as
    per the *Requirements Install Guide* and complete the *Offline Installation Guide*
    instructions.

Test cx_Oracle With Alchemy
```````````````````````````

Installing Oracle Libraries is required if you intend on installing the peek agent.
Instruction for installing the Oracle Libraries are in the *Online Installation Guide*.

Run the following commands in Python: ::

        from sqlalchemy import create_engine

        create_engine('oracle://username:password@hostname:1521/instance')
        engine = create_engine('oracle://enmac:bford@192.168.215.128:1521/enmac')
        engine.execute("SELECT 1")

*You can now start developing*

Building synerty-peek
---------------------

Development
```````````

The peek package has build scripts that generate a development build.
::

        ./pipbuild_platform.sh 0.0.1.dev1

.. NOTE:: Dev build, it doesn't tag, commit or test upload, but still generates a build.

.. WARNING:: Omitting the dot before dev will cause the script to fail as setuptools
    adds the dot in if it's not there, which means the cp commands won't match files.

Production
``````````

The peek package has build scripts that generate a platform build.
::

        ./pipbuild_platform.sh #.#.##
        ./pypi_upload.sh

.. NOTE:: Prod build, it tags, commits and test uploads to testpypi.  If you're building
    for development, skip this step and go back to Development.

.. WARNING:: Omitting the dot before dev will cause the script to fail as setuptools
    adds the dot in if it's not there, which means the cp commands won't match files.
