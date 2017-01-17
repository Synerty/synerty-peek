======================
Peek Development Setup
======================

This documentation is an extension of the Peek Production Platform (ProductionSetup.rst).


Windows Support
---------------



Requirements
````````````

#.  Shapely
    :Download: http://www.lfd.uci.edu/~gohlke/pythonlibs/#shapely
    :From: https://pypi.python.org/pypi/Shapely
    Shapely >= 1.5.17 ::

    pip install ~/Downloads/Shapely-1.5.17-cp35-cp35m-win_amd64.whl

#.  Dependencies
    Run these command in terminal ::

        pip install psycopg2
        pip install pycparser
        pip install cffi
        pip install cryptography
        pip install pytest
        pip install coverage
        pip install pypiwin32

#.  Visual Studio Code
    :Download: https://code.visualstudio.com
    Add PATH to environment variables ::

        "C:\Program Files (x86)\Microsoft VS Code\bin"

DEVELOPING
----------

For platform development (NOTE: Most development will be for the plugin, not platform,
so these instructions are not high priority)

FROM SHELL
``````````

#.  Symlink the tsconfig.json and node_modules file and directory. These steps are run in
        the directory where the projects are checked out from. These are required for
        the frontend typescript compiler.

    #.  ln -s peek-client-fe/peek_client_fe/node_modules .
    #.  ln -s peek-client-fe/peek_client_fe/src/tsconfig.json .
::

    peek@peek:~/project$ ls -la
    lrwxrwxrwx  1 peek sudo   42 Dec 27 21:00 node_modules -> peek-client-fe/peek_client_fe/node_modules
    lrwxrwxrwx  1 peek sudo   47 Dec 27 21:00 tsconfig.json -> peek-client-fe/peek_client_fe/src/tsconfig.json

#.  These steps link the projects under site-packages and installs their dependencies.

    #.  Run the following command ::

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

You can now start developing

Building for Development
````````````````````````

The peek package has build scripts that generate a development build.
#. Dev build, it doesn't tag, commit or test upload, but still generates a build.

::

    # NOTE: Omitting the dot before dev will cause the script to fail as setuptools
    # adds the dot in if it's not there, which means the cp commands won't match files.

    ./pipbuild_platform.sh 0.0.1.dev1
