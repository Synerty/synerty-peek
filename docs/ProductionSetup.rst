========================
Peek Production Platform
========================

This documentation extends Peek Platform (README.rst).


Windows Support
---------------

The Peek platform is designed to run on Linux, however, it is compatible with windows.
This section describes the requirements and configuration for windows.

Requirements
````````````

#.  Chrome
    :Download: https://www.google.com/intl/en/chrome/browser/desktop/index.html?standalone=1#
    :From: https://www.google.com/chrome/

#.  Microsoft .NET Framework 3.5 Service Pack 1
    :Download: https://www.microsoft.com/en-ca/download/details.aspx?id=22

#.  Visual C++ Build Tools 2015
    :Download: http://go.microsoft.com/fwlink/?LinkId=691126&__hstc=268264337.40d7988155305183930d94960a802559.1481662741421.1481662741421.1484335933816.2&__hssc=268264337.1.1484335933816&__hsfp=1223438833&fixForIE=.exe
    :From: http://landinghub.visualstudio.com/visual-cpp-build-tools

#.  Create peek user account (you are not required to be logged in with this account)
    Username: peek
    Password: PASSWORD

#.  Microsoft® SQL Server® 2014 Express
    :Download: https://www.microsoft.com/en-ca/download/details.aspx?id=42299

    *  Shared Feature: check 'LocalDB'
    *  Instance Configuration: change the named instance to 'peek'
    *  Server Configuration: enter the Account Name and Password details for the 'peek'
       user.

    Make Changes in SQL Server Configuration Manager (SQLServerManager12.msc)::

        SQL Server Configuration Manager --> SQL Server Network Configuration -->
        Protocols for PEEK:
            Under the TCP/IP properties set 'IPALL' 'TCP PORT' to '1433'. Select 'Apply'
                then 'OK',
            Enable the 'TCP/IP' Protocol
            Restart the server service.

#.  Node.js 7+ and NPM 3+
    :Download: https://nodejs.org/dist/v7.4.0/node-v7.4.0-x64.msi
    :From: https://nodejs.org/en/download/current/
    Add PATH to environment variables ::

        "%USERPROFILE%\AppData\Roaming\npm"

#.  Install the required NPM packages ::

    npm -g upgrade npm
    npm -g install angular-cli typescript tslint

#.  Python 3.5
    :Download: https://www.python.org/ftp/python/3.5.3/python-3.5.3rc1-amd64.exe
    :From: https://www.python.org/downloads/windows/
    Add PATH to environment variables ::

        "%USERPROFILE%\AppData\Local\Programs\Python\Python35\Scripts\"
        "%USERPROFILE%\AppData\Local\Programs\Python\Python35\"

#.  FreeTDS
    :Download: https://github.com/ramiro/freetds/releases/download/v0.95.95/freetds-v0.95.95-win-x86_64-vs2015.zip
    :From: https://github.com/ramiro/freetds/releases
    Unzip contents into ::

        "%USERPROFILE%\AppData\Local\Programs\Python\Python35\freetds-v0.95.95"

    Add PATH to environment variables ::

        "%USERPROFILE%\AppData\Local\Programs\Python\Python35\freetds-v0.95.95\bin"

    Create 'freetds.conf' in "C:\" ::

    [global]
        port = 1433
        instance = peek
        tds version = 7.0
        dump file = /tmp/freetds.log
-
    :Download: http://indy.fulgan.com/SSL/openssl-1.0.2j-x64_86-win64.zip
    :From: http://indy.fulgan.com/SSL/
    ensure these files are in the system32 folder:
        libeay32.dll
        ssleay32.dll

        You will need to duplicate the above files and name them as per below:
        libeay32MD.dll
        ssleay32MD.dll

#. GitBash
    :Download: https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.1/Git-2.11.0-64-bit.exe
    :From: https://git-for-windows.github.io

    *  Configuring Extra Options: check 'Enable Symbolic Links'

    Add PATH to environment variables ::

        "C:\Program Files\Git\bin"

OS Commands
```````````

The config file for each service in the peek platform describes the location of the BASH
interpreter. Peek is coded to use the bash interpreter and basic posix compliant utilites
for all OS commands.

When peek generates it's config it should automatically choose the right interpreter.
     "C:\Program Files\Git\bin\bash.exe" if isWindows else "/bin/bash"

SymLinks
````````


Enabling SymLinks (Note: This setting has no effect on user accounts that belong to the
 Administrators group.
Those users will always have to run mklink in an elevated environment as Administrator.)

#.  Launch: "gpedit.msc"
#.  Navigate: "Computer configuration → Windows Settings → Security Settings → Local
    Policies → User Rights Assignment → Create symbolic links"
#.  Add the user or group that you want to allow to create symbolic links
#.  You will need to logout and log back in for the change to take effect

https://github.com/git-for-windows/git/wiki/Symbolic-Links

PYTHON ENVIRONMENT
------------------

This section describes how to setup the Python environments.

FROM SHELL
``````````

#.  Checkout the following, all in the same folder
    :From: https://github.com/Synerty
    ::

    git clone -c core.symlinks=true <URL>
-
    #.  synerty-peek
    #.  peek-plugin-base
    #.  peek-agent
    #.  peek-client
    #.  peek-client-fe
    #.  peek-platform
    #.  peek-server
    #.  peek-server-fe
    #.  peek-worker

Building for Production
```````````````````````

NOTE: If you're building for development skip this step and continue through to
Development Setup.

The peek package has build scripts that generate a platform build.
#. Prod build, it tags, commits and test uploads to testpypi

::

    # NOTE: Omitting the dot before dev will cause the script to fail as setuptools
    # adds the dot in if it's not there, which means the cp commands won't match files.

    ./pipbuild_platform.sh 0.0.8
    ./pypi_upload.sh

