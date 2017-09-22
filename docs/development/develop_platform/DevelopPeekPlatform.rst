=====================
Develop Peek Platform
=====================

.. WARNING:: This document extends, *Setup OS Requirements Windows* or the *Setup OS
    Requirements Debian* depending on your OS.

Most development will be for the plugins, not platform, so these instructions are not
high priority.

Synerty recommends the Atlassian suite of developer tools.

Bitbucket to manage and share your Git repositories

:URL: `<https://www.bitbucket.org>`_

SourceTree to visually manage and interact with your Git repositories

:URL: `<https://www.sourcetreeapp.com>`_

Bitbucket can be integrated with Jira (issue management) and Bamboo (continuous
integration).

.. note::   The reader needs be familiar with, or will become familar with the following:

            *   `GIT <https://git-scm.com>`_
            *   `Python3.5+ <https://www.python.org>`_
            *   `Python Twisted <http://twistedmatrix.com>`_
            *   HTML
            *   CSS
            *   `Bootstrap3 <http://getbootstrap.com>`_
            *   `TypeScript <https://www.typescriptlang.org>`_
            *   `Angular <https://angular.io>`_ (Angular2+, not AngularJS aka Angular1)
            *   `NativeScript <https://www.nativescript.org>`_


.. note:: This a cross platform development guide, all commands are writen for bash.

    Bash is installed by default on Linux.

    Windows users should use bash from msys, which comes with git for windows,
    :ref:`setup_msys_git`.

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

:Synerty's Repositories: `<https://bitbucket.org/account/user/synerty/projects/PEEK>`_

*  synerty-peek

*  peek-plugin-base

*  peek-agent

*  peek-client

*  peek-mobile

*  peek-platform

*  peek-server

*  peek-admin

*  peek-worker

Clone Peek Repositories
```````````````````````

Checkout repositories all in the same folder

https://bitbucket.org/synerty/synerty-peek.git

Use this script to insert individual peek modules.  Update {gitAccount} and
{repository} in the script below: ::

        REPO="{repository}"

        if [ ! -d ~peek/peek-dev ]; then
            mkdir ~peek/peek-dev
            cd ~peek/peek-dev/
            git clone https://bitbucket.org/synerty/$REPO.git
            cd ~peek/peek-mobile/$REPO
            git config --unset core.symlink
            git config --add core.symlink true
        else
            echo "ALERT: `pwd` directory already exists.  Please investigate then retry."
        fi

        cd ~peek/peek-dev/
        ls -l

Use this script to clone all repositories.  Update {gitAccount} in the script below: ::


        REPOS="synerty-peek"
        REPOS="$REPOS peek-plugin-base"
        REPOS="$REPOS peek-agent"
        REPOS="$REPOS peek-client"
        REPOS="$REPOS peek-mobile"
        REPOS="$REPOS peek-platform"
        REPOS="$REPOS peek-server"
        REPOS="$REPOS peek-admin"
        REPOS="$REPOS peek-worker"

        if [ ! -d ~peek/peek-dev ]; then
        mkdir ~peek/peek-dev
        cd ~peek/peek-dev/
        for REPO in ${REPOS[*]}
        do
            echo $REPO
            git clone https://bitbucket.org/synerty/$REPO.git
            cd ~peek/peek-dev/$REPO
            git config --unset core.symlink
            git config --add core.symlink true
            cd ~peek/peek-dev/
        done
        else
            cd ~peek/peek-dev/
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

        cd ~peek/peek-dev/peek-mobile/peek_mobile/build-web
        [ -d node_modules ] && rm -rf node_modules
        npm install
        cd ~peek/peek-dev/peek-mobile/peek_mobile/build-ns
        [ -d node_modules ] && rm -rf node_modules
        npm install
        cd ~peek/peek-dev/peek-admin/peek_admin/build-web
        [ -d node_modules ] && rm -rf node_modules
        npm install

Install synerty-peek Dependencies
`````````````````````````````````

These steps link the projects under site-packages and installs their dependencies.

For synerty-peek, run the following commands: ::

        cd ~peek/peek-dev/synerty-peek
        ./pip_uninstall_and_develop.sh

For repositories and plugins, run from their directory ::

            python setup.py develop

Compile Front End Packages
``````````````````````````

Symlink the tsconfig.json and node_modules file and directory in the parent directory
of peek-mobile, peek-admin and the plugins. These steps are run in the directory
where the projects are checked out from. These are required for the frontend typescript
compiler.

Run the following commands: ::

        cd ~peek/peek-dev/peek-mobile/peek_mobile/build-web
        ng build
        cd ~peek/peek-dev/peek-admin/peek_admin/build-web
        ng build


Develop
```````
You are ready to develop synerty-peek services

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
