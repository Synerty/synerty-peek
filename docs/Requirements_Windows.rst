=================================
Windows Requirements Instal Guide
=================================

.. note:: For offline installation some steps are required to be installed on another
    online server for the files to be packaged and transfered to the offline server.

Windows Support
---------------

The Peek platform is designed to run on Linux, however, it is compatible with windows.

OS Commands
```````````

The config file for each service in the peek platform describes the location of the BASH
interpreter. Peek is coded to use the bash interpreter and basic posix compliant utilites
for all OS commands.

When peek generates it's config it should automatically choose the right interpreter. ::

        "C:\Program Files\Git\bin\bash.exe" if isWindows else "/bin/bash"

Software Requirements
`````````````````````

#.  Create peek user account

    *  Username: peek
    *  Password: PA$$W0RD
    *  sign in to the peek account

#.  Chrome,

    :Download: `<https://www.google.com/intl/en/chrome/browser/desktop/index.html?standalone=1#>`_
    :From: `<https://www.google.com/chrome/>`_

#.  Microsoft .NET Framework 3.5 Service Pack 1,

    :Download: `<http://download.microsoft.com/download/2/0/e/20e90413-712f-438c-988e-fdaa79a8ac3d/dotnetfx35.exe>`_

#.  Visual C++ Build Tools 2015,

    *  Online Installation:

    :Download: `<http://go.microsoft.com/fwlink/?LinkId=691126&__hstc=268264337.40d7988155305183930d94960a802559.1481662741421.1481662741421.1484335933816.2&__hssc=268264337.1.1484335933816&__hsfp=1223438833&fixForIE=.exe>`_
    :From: `<http://landinghub.visualstudio.com/visual-cpp-build-tools>`_

    *  Offline Installation:

    :Download: `<https://www.microsoft.com/en-US/download/details.aspx?id=48146>`_

#.  Microsoft® SQL Server® 2014 Express,

    :From: `<https://www.microsoft.com/en-ca/download/details.aspx?id=42299>`_

    #.  Shared Feature: check 'LocalDB'

    #.  Instance Configuration: change the named instance to 'peek'

    #.  Server Configuration: enter the Account Name and Password details for the 'peek'
        user.

    #.  Start Microsoft SQL Server Management Studio --> Connect to PEEK database
    engine --> create new database 'peek'

#.  Make Changes in SQL Server Configuration Manager (SQLServerManager12.msc)

    SQL Server Configuration Manager --> SQL Server Network Configuration -->
    Protocols for PEEK:

    #.  Under the TCP/IP properties set 'IPALL' 'TCP PORT' to '1433'. Select 'Apply' then
    'OK',

        .. image:: sqlexpress_config/set_tcp_port.png

    #.  Enable the 'TCP/IP' Protocol

        .. image:: sqlexpress_config/enable_tcpip.png

    #.  Restart the server service.

#.  Node.js 7+ and NPM 3+,

    :Download: `<https://nodejs.org/dist/v7.4.0/node-v7.4.0-x64.msi>`_
    :From: `<https://nodejs.org/en/download/current/>`_

    #.  Change install path ::

            C:\Users\peek\nodejs

    #.  Add PATH to environment variables ::

            "%USERPROFILE%\AppData\Roaming\npm"

    #.  Install the required NPM packages ::

            npm -g install angular-cli typescript tslint nativescript

.. note:: For Offline installation, package the installed nodejs files and installed
    modules.  Unpackage in the same directory locations on the offline server.

#.  Python 3.5,

    :Download: `<https://www.python.org/ftp/python/3.5.3/python-3.5.3rc1-amd64.exe>`_
    :From: `<https://www.python.org/downloads/windows/>`_

    #.  Install to PATH "%USERPROFILE%\Python35\"

    #.  Add PATH(s) to environment variables ::

        "%USERPROFILE%\Python35\"
        "%USERPROFILE%\Python35\Scripts\"

.. note:: For Offline installation, package the installed python files after
    synerty-peek package has been install and configured on the online server.  Unpackage
     in the same directory locations on the offline server.

#.  FreeTDS,

    :Download: `<https://github.com/ramiro/freetds/releases/download/v0.95.95/freetds-v0.95.95-win-x86_64-vs2015.zip>`_
    :From: `<https://github.com/ramiro/freetds/releases>`_

    #.  Unzip contents into ::

        "%USERPROFILE%\freetds-v0.95.95"

    #.  Add PATH to environment variables ::

        "%USERPROFILE%\freetds-v0.95.95\bin"

    #.  Create 'freetds.conf' in "C:\" ::

            [global]
                port = 1433
                instance = peek
                tds version = 7.0
                dump file = /tmp/freetds.log

    #.  Test FreeTDS is working


#.  dll files,

    :Download: `<http://indy.fulgan.com/SSL/openssl-1.0.2j-x64_86-win64.zip>`_
    :From: `<http://indy.fulgan.com/SSL/>`_

    ensure these files are in the system32 folder:
    *  libeay32.dll

    *  ssleay32.dll

    *  You will need to duplicate the above files and name them as per below:

        *  libeay32MD.dll

        *  ssleay32MD.dll

#. GitBash,

    :Download: `<https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.1/Git-2.11.0-64-bit.exe>`_
    :From: `<https://git-for-windows.github.io>`_

    #.  Configuring Extra Options: check 'Enable Symbolic Links'

    #.  Add PATH to environment variables ::

        "C:\Program Files\Git\bin"

#.  Upgrade pip ::

        python -m pip install --upgrade pip

#.  Shapely,

    :Download: `<http://www.lfd.uci.edu/~gohlke/pythonlibs/#shapely>`_
    :From: `<https://pypi.python.org/pypi/Shapely>`_

    Shapely >= 1.5.17 ::

        pip install ~/Downloads/Shapely-1.5.17-cp35-cp35m-win_amd64.whl

Installing Oracle Libraries (Optional)
``````````````````````````````````````

The oracle libraries are optional. Install them where the agent runs if you are going
to interface with an oracle database.

#.  cx_Oracle

    #.  Install Oracle Instant Client

        :Download: `<http://download.oracle.com/otn/nt/instantclient/121020/instantclient-basic-windows.x64-12.1.0.2.0.zip>`_
        :From: `<http://www.oracle.com/technetwork/topics/winx64soft-089540.html>`_

        Unzip contents into ::

                "%USERPROFILE%\Oracle\12.1.0.2.0\instantclient_12_1_basic"

        Add 'ORACLE_HOME' to the environment variables and set the path ::

                "%USERPROFILE%\Oracle\12.1.0.2.0\instantclient_12_1_basic"

        Add to the 'PATH' to environment variables ::

                "%USERPROFILE%\Oracle\12.1.0.2.0\instantclient_12_1_basic"

    #.  Install cx_Oracle

        :Download: `<https://pypi.python.org/packages/50/c0/de24ec02484eb9add03cfbd28bd3c23fe137551501a9ca4498f30109621e/cx_Oracle-5.2.1-12c.win-amd64-py3.5.exe#md5=b505eaceceaa3813cf6bfe701ba92c3e>`_
        :From: `<https://pypi.python.org/pypi/cx_Oracle/5.2.1>`_

    #.  Test cx_Oracle in python ::

            >>>
            >>> import cx_Oracle
            >>> con = cx_Oracle.connect('oracle://username:password@hostname:1521/instance')
            >>> print con.version
            12.1.0.2.0
            >>>con.close()

            con = cx_Oracle.connect('oracle://enmac:bford@192.168.215.128:1521/enmac')

    #.  Test cx_Oracle with Alchemy ::

            >>>
            >>> from sqlalchemy import create_engine

            >>> create_engine('oracle://username:password@hostname:1521/instance')
            >>> engine = create_engine('oracle://enmac:bford@192.168.215.128:1521/enmac')
            >>> engine.execute("SELECT 1")

SymLinks
````````

Enabling SymLinks.

.. Note:: This setting has no effect on user accounts that belong to the Administrators
    group.  Those users will always have to run mklink in an elevated environment as
    Administrator.

#.  Launch: "gpedit.msc"

    #.  Navigate: "Computer configuration → Windows Settings → Security Settings → Local
    Policies → User Rights Assignment → Create symbolic links"

    #.  Add the user or group that you want to allow to create symbolic links

    #.  You will need to logout and log back in for the change to take effect

`<https://github.com/git-for-windows/git/wiki/Symbolic-Links>`_

Installing synerty-peek
```````````````````````

.. note:: If offline installation is required, complete the Installing synerty-peek
    setup then return to the Offline Installation Guide.

From here you will be deploying either the **Production Platform** (ProductionSetup.rst)
or the **Development Setup** (DevelopmentSetup.rst).

Offline Installation Guide
--------------------------

.. warning:: For offline installation, complete the Installation Guide on another
    online server first.  This is because some software requires online access to install.

Software Requirements
`````````````````````

The offline installation guide has the same steps as the Installation Guide
excluding the steps listed below:

#.  Node.js 7+ and NPM 3+,

    From the online server, package the nodejs files and npm files.  Unpackage these
    files on the offline server.

    Nodejs and NPM files are located::

            ~\nodejs
            ~\AppData\Roaming\npm

    #.  Add PATH(s) to environment variables ::

            "%USERPROFILE%\AppData\Roaming\npm"

#.  Python 3.5,

    From the online server, package the python files.  Unpackage these files on the
    offline server.

    Python35 files are located::

            ~\Python35

    #.  Add PATH(s) to environment variables ::

            "%USERPROFILE%\Python35\"
            "%USERPROFILE%\Python35\Scripts\"

.. note:: For Offline installation, package the installed python files after
    synerty-peek package has been install and configured.  Unpackage in the same directory
    locations on the offline server.

    #.  Refreshing symbolic links::

            $ cd `dirname $(which python)`/lib/site-packages/

            $ rm -r peek_server_fe/src/app/peek_plugin* peek_server_fe/node_modules/peek_plugin*

            $ rm -r peek_client_fe/src/app/peek_plugin* peek_client_fe/node_modules/peek_plugin*

