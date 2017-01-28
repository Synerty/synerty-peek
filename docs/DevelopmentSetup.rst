=================
Development Setup
=================

.. WARNING:: This document extends, Synerty Peek Installation (Installation.rst).


.. NOTE:: Most development will be for the plugin, not platform, so these instructions
    are not high priority.

Hardward Recommendation
-----------------------

32gb of ram (minumum 16gb)

Windows
-------

Requirements
````````````

#.  Dependencies

    Run these command in terminal ::

        pip install psycopg2
        pip install pycparser
        pip install cffi
        pip install cryptography
        pip install pytest
        pip install coverage
        pip install pypiwin32

#.  Install and Configure RabbitMQ

    #.  Install Erlang
        :Download: `<http://www.erlang.org/download/otp_win64_19.2.exe>`_
        :From: `<http://www.erlang.org/downloads>`_

    #.  Install rabbitmq
        :Download: `<http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-3.6.6.exe>`_
        :From: `<http://www.rabbitmq.com/download.html>`_

    TODO:

#.  Install and Configure Redis

    :Download: `<http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-3.6.6.exe>`_
    :From: `<http://www.rabbitmq.com/download.html>`_

    TODO:

#.  Visual Studio Code,

    :Download: `<https://code.visualstudio.com>`_

    Add PATH to environment variables ::

        "C:\Program Files (x86)\Microsoft VS Code\bin"


Enable your device for development
``````````````````````````````````


`<https://msdn.microsoft.com/en-us/windows/uwp/get-started/enable-your-device-for-development>`_

FROM SHELL
``````````

#.  Checkout the following, all in the same folder,

    :From: `<https://github.com/Synerty>`_

*  Repositories
    #.  synerty-peek
    #.  peek-plugin-base
    #.  peek-agent
    #.  peek-client
    #.  peek-client-fe
    #.  peek-platform
    #.  peek-server
    #.  peek-server-fe
    #.  peek-worker

#.  Install front end packages

        Go to the peek-server-fe/peek_server_fe/ and peek-client-fe/peek_client_fe/ ::

        $ npm install

#.  Symlink the tsconfig.json and node_modules file and directory in the parent
directory of peek-client-fe, peek-server-fe and the plugins. These steps are run in the
directory where the projects are checked out from. These are required for the frontend
typescript compiler. ::

        ln -s peek-client-fe/peek_client_fe/node_modules .
        ln -s peek-client-fe/peek_client_fe/tsconfig.json .
    #.  ::

            $ cd peek-server-fe/peek_server_fe/
            $ ng build

            $ cd peek-client-fe/peek_client_fe/
            $ ng build

#.  These steps link the projects under site-packages and installs their dependencies.

    #.  Run the following commands ::

            cd synerty-peek
            ./pip_uninstall_and_develop.sh

SETTING UP PYCHARM
``````````````````

#.  Open pycharm,

    #.  Open the peek project, open in new window
    #.  Open each of the other projects mentioned above, add to current window

#.  File -> Settings (Ctrl+Alt+S with eclipse keymap)

    #. Editor -> Inspection (use the search bar for finding the inspections)

        #.  Disable Python -> "PEP8 Naming Convention Violation"
        #.  Change Python -> "Type Checker" from warning to error
        #.  Change Python -> "Incorrect Docstring" from warning to error
        #.  Change Python -> "Missing type hinting ..." from warning to error
        #.  Change Python -> "Incorrect call arguments" from warning to error
        #.  Change Python -> "Unresolved references" from warning to error

    #. Project -> Project Dependencies

        #.  peek_platform depends on -> plugin_base
        #.  peek_server depends on -> peek_platform, peek_server_fe
        #.  peek_client depends on -> peek_platform, peek_client_fe
        #.  peek_agent depends on -> peek_platform
        #.  peek_worker depends on -> peek_platform

    #.  Languages & Frameworks -> TypesScript

        #.  Node interpreter -> ~/node-v7.1.0/bin/node
        #.  Enable TypeScript Compiler -> Checked
        #.  Set options manually -> Checked
        #.  Command line options -> --target es5 --experimentalDecorators --lib es6,dom --sourcemap --emitDecoratorMetadata
        #.  Generate source maps -> Checked

        .. image::pycharm_setup/settings_typescript.png

*You can now start developing*

Debian Linux
------------


Building synerty-peek
---------------------

Building for Production
```````````````````````

.. NOTE:: If you're building for development skip this step and continue through to
    Development Setup.

The peek package has build scripts that generate a platform build.

.. NOTE:: Prod build, it tags, commits and test uploads to testpypi.

.. WARNING:: Omitting the dot before dev will cause the script to fail as setuptools
    adds the dot in if it's not there, which means the cp commands won't match files.

    ::

        ./pipbuild_platform.sh 0.0.8
        ./pypi_upload.sh

Building for Development
````````````````````````

The peek package has build scripts that generate a development build.

.. NOTE:: Dev build, it doesn't tag, commit or test upload, but still generates a build.

.. WARNING:: Omitting the dot before dev will cause the script to fail as setuptools
    adds the dot in if it's not there, which means the cp commands won't match files.

    ::

        ./pipbuild_platform.sh 0.0.1.dev1
