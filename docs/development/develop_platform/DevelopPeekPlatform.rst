=====================
Develop Peek Platform
=====================

.. WARNING:: This document extends, *Setup OS Requirements Windows* or the *Setup OS
    Requirements Linux* depending on your OS.

Most development will be for the plugins, not platform, so these instructions are not
high priority.

Synerty uses PyCharm as its choice of IDE and Git management tool.

GitLab to manage and share your Git repositories: https://gitlab.synerty.com

.. note::   The reader needs be familiar with, or will become familiar with the following:

            *   `GIT <https://git-scm.com>`_
            *   `Python 3.6+ <https://www.python.org>`_
            *   `Python Twisted <http://twistedmatrix.com>`_
            *   HTML
            *   SCSS
            *   `Ant Design <https://ng.ant.design/>`_
            *   `TypeScript <https://www.typescriptlang.org>`_
            *   `Angular <https://angular.io>`_ (Angular2+, not AngularJS aka Angular1)
            *   `CapacitorJS <https://capacitorjs.com/>`_


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

Synerty Peek Repositories
`````````````````````````

`Synerty's Repositories: <https://gitlab.synerty.com/peek>`_

*  synerty-peek

*  peek-plugin-base

*  peek-plugin-base-js

*  peek-agent-service

*  peek-office-service

*  peek-field-app

*  peek-platform

*  peek-logic-service

*  peek-admin-app

*  peek-worker-service

Fork Peek Repositories
```````````````````````

Create a GitLab group using your hyphenated full name as the namespace, i.e.

https://gitlab.synerty.com/john-smith

Create a GitLab subgroup under your namespace named peek, i.e.

https://gitlab.synerty.com/john-smith/peek

Create a GitLab subgroup under your namespace named peek-util, i.e.

https://gitlab.synerty.com/john-smith/peek-util

Create a GitLab access token with a 24 hour expiry :

https://gitlab.synerty.com/profile/personal_access_tokens

Fork all repositories from https://gitlab.synerty.com/peek to your namespace/peek subgroup: ::

        export ACCESS_TOKEN="" # https://gitlab.synerty.com/profile/personal_access_tokens
        export GROUP_ID="2" # https://gitlab.synerty.com/peek
        export YOUR_SUBGROUP_ID="" # Your namespace/peek subgroup id to fork to

        function loadProjectIds() {
            curl --location --request GET "https://gitlab.synerty.com/api/v4/groups/${GROUP_ID}/projects?per_page=100" \
                --header 'Content-Type: application/json' \
                --header "Authorization: Bearer ${ACCESS_TOKEN}" \
                --header 'Content-Type: application/json' \
                --data-raw '' | jq '.[] .id'
        }

        for REPO_ID in `loadProjectIds`
        do
            curl --location --request POST "https://gitlab.synerty.com/api/v4/projects/${REPO_ID}/fork" \
            --header 'Content-Type: application/json' \
            --header "Authorization: Bearer ${ACCESS_TOKEN}" \
            --data-raw '{"id":"${ID}","namespace":${YOUR_SUBGROUP_ID}}'
        done

Fork all repositories from https://gitlab.synerty.com/peek-util to your namespace/peek-util subgroup: ::

        export ACCESS_TOKEN="" # https://gitlab.synerty.com/profile/personal_access_tokens
        export GROUP_ID="26" # https://gitlab.synerty.com/peek-util
        export YOUR_SUBGROUP_ID="" # Your namespace/peek-util subgroup id to fork to

        function loadProjectIds() {
            curl --location --request GET "https://gitlab.synerty.com/api/v4/groups/${GROUP_ID}/projects?per_page=100" \
                --header 'Content-Type: application/json' \
                --header "Authorization: Bearer ${ACCESS_TOKEN}" \
                --header 'Content-Type: application/json' \
                --data-raw '' | jq '.[] .id'
        }

        for REPO_ID in `loadProjectIds`
        do
            curl --location --request POST "https://gitlab.synerty.com/api/v4/projects/${REPO_ID}/fork" \
            --header 'Content-Type: application/json' \
            --header "Authorization: Bearer ${ACCESS_TOKEN}" \
            --data-raw '{"id":"${ID}","namespace":${YOUR_SUBGROUP_ID}}'
        done

Clone all of the projects in your namespace/peek subgroup to ~/dev-peek/: ::

        export ACCESS_TOKEN="" # https://gitlab.synerty.com/profile/personal_access_tokens
        export YOUR_NAMESPACE="" # Your GitLab namespace group, i.e. "john-smith"
        export YOUR_SUBGROUP_ID="" # Your GitLab namespace/peek subgroup id
        export DIR="~/dev-peek"

        function loadProjectIds() {
            curl --location --request GET "https://gitlab.synerty.com/api/v4/groups/${YOUR_SUBGROUP_ID}/projects?per_page=100" \
                --header 'Content-Type: application/json' \
                --header "Authorization: Bearer ${ACCESS_TOKEN}" \
                --header 'Content-Type: application/json' \
                --data-raw '' | jq '.[] .name'
        }

        if [ ! -d ${DIR} ]
        then
            mkdir ${DIR}
            cd $DIR
            for REPO_NAME in `loadProjectIds`
            do
                NAME="${REPO_NAME%\"}"
                NAME="${NAME#\"}"
                URL=https://gitlab.synerty.com/$YOUR_NAMESPACE/$NAME.git
                echo $URL
                git clone $URL
            done
        fi

Clone all of the projects in your namespace/peek-util subgroup to ~/dev-peek-util/: ::

        export ACCESS_TOKEN="" # https://gitlab.synerty.com/profile/personal_access_tokens
        export YOUR_NAMESPACE="" # Your GitLab namespace group, i.e. "john-smith"
        export YOUR_SUBGROUP_ID="" # Your GitLab namespace/peek subgroup id
        export DIR="~/dev-peek-util"

        function loadProjectIds() {
            curl --location --request GET "https://gitlab.synerty.com/api/v4/groups/${YOUR_SUBGROUP_ID}/projects?per_page=100" \
                --header 'Content-Type: application/json' \
                --header "Authorization: Bearer ${ACCESS_TOKEN}" \
                --header 'Content-Type: application/json' \
                --data-raw '' | jq '.[] .name'
        }

        if [ ! -d ${DIR} ]
        then
            mkdir ${DIR}
            cd $DIR
            for REPO_NAME in `loadProjectIds`
            do
                NAME="${REPO_NAME%\"}"
                NAME="${NAME#\"}"
                URL=https://gitlab.synerty.com/$YOUR_NAMESPACE/$NAME.git
                echo $URL
                git clone $URL
            done
        fi

.. NOTE:: core.symlink:  If false, symbolic links are checked out as small plain files
    that contain the link text.  The default is true, except *git-clone* or *git-init*
    will probe and set core.symlinks false if appropriate when the repository is created.

Setup Cloned Repositories For Development
`````````````````````````````````````````
Run setup.py in all of the repositories located in ~/dev-peek/: ::

        set -e

        cd ~/dev-peek
        for DIR in */
        do
            cd "$DIR"
            NAME=${PWD##*/}
            echo "$NAME"
            pip uninstall -y "$NAME"
            python setup.py develop
            cd ..
        done

Run setup.py in all of the repositories located in ~/dev-peek-util/: ::

        set -e

        cd ~/dev-peek-util
        for DIR in */
    do
            cd "$DIR"
            NAME=${PWD##*/}
            echo "$NAME"
            pip uninstall -y "$NAME"
            python setup.py develop
            cd ..
        done

Install Front End Modules
`````````````````````````

Remove the old npm modules files and re-install for field, office and logic service frontend
packages.  Run the following commands: ::

        cd ~/dev-peek/peek-field-app/peek_field_app
        [ -d node_modules ] && rm -rf node_modules
        npm i
        cd ~/dev-peek/peek-office-app/peek_office_app
        [ -d node_modules ] && rm -rf node_modules
        npm i
        cd ~/dev-peek/peek-admin-app/peek_admin_app
        [ -d node_modules ] && rm -rf node_modules
        npm i

Configure Peek Field, Office, Logic Service Settings
````````````````````````````````````````````````````

Open the config file located at ~/peek/peek-field-service.home/config.json

Set the property frontend.docBuildEnabled to false.

Set the property frontend.webBuildEnabled to false.

Open the config file located at ~/peek/peek-office-service.home/config.json

Set the property frontend.docBuildEnabled to false.

Set the property frontend.webBuildEnabled to false.

Open the config file located at ~/peek/peek-logic-service.home/config.json

Set the property frontend.docBuildEnabled to false.

Set the property frontend.webBuildEnabled to false.

Set the property httpServer.admin.recovery_user.username to "recovery".

Set the property httpServer.admin.recovery_user.password to "synerty".

Compile Front End Packages For Development
``````````````````````````````````````````

Run the following commands in separate terminal sessions: ::

        # Terminal 1
        cd ~/dev-peek/peek-field-app/peek_field_app
        ng build --watch

        # Terminal 2
        cd ~/dev-peek/peek-admin-app/peek_admin_app
        ng build --watch

        # Terminal 3
        cd ~/dev-peek/peek-office-app/peek_office_app
        ng build --watch

        # Terminal 4
        run_peek_logic_service

        # Terminal 5
        run_peek_office_service

Viewing Peek Services In The Browser
````````````````````````````````````

Peek Mobile:    http://localhost:8000

Peek Desktop:   http://localhost:8002

Peek Admin:     http://localhost:8010

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
