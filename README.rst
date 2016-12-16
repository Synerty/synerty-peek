=============
Peek Platform
=============

A platform for python written for Twisted.

This is the meta package that installs the platform.

If you don't want to install the whole platform, you can install just the service you want

#.  peek_server
#.  peek_worker
#.  peek_agent
#.  peek_client


Windows Support
---------------

The Peek platform is designed to run on Linux, however, it is compatible with windows.
This section describes the requirements and configuration for windows.

Requirements
````````````

GitBash
:Download: https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.1/Git-2.11.0-64-bit.exe
:From: https://git-for-windows.github.io


OS Commands
```````````

The config file for each service in the peek platform describes the location of the BASH
interpreter. Peek is coded to use the bash interpreter and basic posix compliant utilites
for all OS commands.

When peek generates it's config it should automatically choose the right interpreter.
     "C:\Program Files\Git\bin\bash.exe" if isWindows else "/bin/bash"

SymLinks
````````

:TODO BRENTON: Include instructions on how to enable windows symlinks
See peek_platform.WindowsPatch for my cross platform symlink code.
http://superuser.com/questions/104845/permission-to-make-symbolic-links-in-windows-7




DEVELOPING
----------

For platform development (NOTE: Most development will be for the plugin, not platform, so these instructions are not high priority)
#.      Checkout the following, all in the same folder
    #.  peek
    #.  plugin_base
    #.  peek_agent
    #.  peek_client
    #.  peek_client_fe
    #.  peek_platform
    #.  peek_server
    #.  peek_server_fe
    #.   peek_worker
#.  Open pycharm,
    #.  open the peek project, open in new window
    #.  Open each of the other projects mentioned above, add to current window
#. File -> Settings (Ctrl+Alt+S with eclipse keymap)
    #. Editor -> Inspection (use the search bar for finding the inspections)
        #. Disable Python -> "PEP8 Naming Convention Violation"
        #. Change Python -> "Type Checker" from warning to error
        #. Change Python -> "Incorrect Docstring" from warning to error
        #. Change Python -> "Missing type hinting ..." from warning to error
    #. Project -> Project Dependencies
        #.  peek_platform depends on -> plugin_base
        #.  peek_server depends on -> peek_platform, peek_server_fe
        #.  peek_client depends on -> peek_platform, peek_client_fe
        #.  peek_agent depends on -> peek_platform
        #.  peek_worker depends on -> peek_platform

Building
````````

The peek package has build scripts that generate a platform build.
It has two modes
#. Prod build, it tags, commits and test uploads to testpypi
#. Dev build, it doesn't tag, commit or test upload, but still generates a build.

    # For a dev build
    ./pipbuild_platform.sh 0.0.1dev1

    # For a prod build
    ./pipbuild_platform.sh 0.0.8
    ./pypi_upload.sh
