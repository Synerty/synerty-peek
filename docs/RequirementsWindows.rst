==================================
Windows Requirements Install Guide
==================================

.. note:: For offline installation some steps are required to be installed on another
online server for the files to be packaged and transferred to the offline server.

The Peek platform is designed to run on Linux, however, it is compatible with windows.

OS Commands
-----------

The config file for each service in the peek platform describes the location of the BASH
interpreter. Peek is coded to use the bash interpreter and basic posix compliant utilities
for all OS commands.

When peek generates it's config it should automatically choose the right interpreter. ::

        "C:\Program Files\Git\bin\bash.exe" if isWindows else "/bin/bash"

Online Installation
-------------------

Software Requirements
`````````````````````

#.  Create peek user account

    *  Account Type: Administrator

    *  Username: ::

            peek

    *  Password: ::

            PA$$W0RD

    *  sign in to the peek account

#.  7zip (optional),

    :Download: `<http://www.7-zip.org/a/7z1604-x64.exe>`_
    :From: `<http://www.7-zip.org/download.html>`_


#.  Notepad ++ (optional),

    :Download: `<https://notepad-plus-plus.org/repository/7.x/7.3.2/npp.7.3.2.Installer.x64.exe>`_
    :From: `<https://notepad-plus-plus.org>`_

#.  Microsoft .NET Framework 3.5 Service Pack 1,

    *  Online Installation:

    :Download: `<http://download.microsoft.com/download/2/0/e/20e90413-712f-438c-988e-fdaa79a8ac3d/dotnetfx35.exe>`_
    :From: `<https://www.microsoft.com/en-ca/download>`_

    *  Offline Installation:

    :Download: `<https://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe>`_

    .. note:: Restart if prompted to restart.

#.  Visual C++ Build Tools 2015,

    *  Online Installation:

    :Download: `<http://go.microsoft.com/fwlink/?LinkId=691126&__hstc=268264337.40d7988155305183930d94960a802559.1481662741421.1481662741421.1484335933816.2&__hssc=268264337.1.1484335933816&__hsfp=1223438833&fixForIE=.exe>`_
    :From: `<http://landinghub.visualstudio.com/visual-cpp-build-tools>`_

    *  Offline Installation:
    Install using the ISO
    :Download: `<https://www.microsoft.com/en-US/download/details.aspx?id=48146>`_


#.  Microsoft® SQL Server® 2014 Express,

    :From: `<https://www.microsoft.com/en-ca/download/details.aspx?id=42299>`_

    #.  Choose directory for extracted files: ::

            C:\SQLEXPRWT_x64_ENU\

    #.  Select "New SQL Server stand-alone installation"

    #.  Feature Selection: check all Features

        .. image:: windows_installation_screenshots/SQLServer-FeatureSelection.jpg

    #.  Instance Configuration: change the named instance to 'peek'. This will update
    the 'Instance ID'

    #.  Server Configuration: Select browse from the 'Account Name' drop-list and check
     names for 'peek'.  Select ok then enter the account password

        .. image:: windows_installation_screenshots/SQLServer-ServerConfiguration.jpg

    #.  Database Engine Configuration: Leave the default settings

    #.  Start Microsoft SQL Server Management Studio --> Connect to PEEK database
    engine --> create new database 'peek'

#.  Make Changes in SQL Server Configuration Manager (SQLServerManager12.msc)

    SQL Server Configuration Manager --> SQL Server Network Configuration -->
    Protocols for PEEK:

    #.  Under the TCP/IP properties set 'IPALL' 'TCP PORT' to '1433'. Select 'Apply' then
    'OK',

        .. image:: windows_installation_screenshots/set_tcp_port.png

    #.  Enable the 'TCP/IP' Protocol

        .. image:: windows_installation_screenshots/enable_tcpip.png

    #.  Restart the server service.

        .. image:: windows_installation_screenshots/SQLServer-RestartServices.jpg

#.  Node.js 7+ and NPM 3+,

    :Download: `<https://nodejs.org/dist/v7.4.0/node-v7.4.0-x64.msi>`_
    :From: `<https://nodejs.org/en/download/current/>`_

    #.  Change install path ::

            C:\Users\peek\nodejs

    #.  Confirm PATH to environment variables ::

            C:\Users\peek\AppData\Roaming\npm
            C:\Users\peek\nodejs\

    #.  Run the Command Prompt as Administrator and run the following commands: ::

            npm -g install angular-cli typescript tslint nativescript

        This will install the required NPM packages

        #.  Do you want to run the setup script? ::

                Y

            .. image:: windows_installation_screenshots/Nativescript-Install.jpg

        #.  Allow the script to install Chocolatey(It's mandatory for the rest of the
        script) ::

                A

        #.  Do you want to install the Android emulator?: ::

                N

            .. image:: windows_installation_screenshots/Nativescript-InstallComplete.jpg

        #.  Once the installation is complete press 'ctrl+c' to exit the PowerShel
        shell then in the command prompt run ::

                tns doctor

            .. image:: windows_installation_screenshots/Nativescript-tnsDoctor.jpg

    #.  Confirm Environment Variable ANDROID_HOME ::

            C:\Users\peek\AppData\Local\Android\android-sdk

    #.  Confirm Environment Variable JAVA_HOME ::

            C:\Program Files\Java\jdk1.8.0_121

    .. note:: For Offline installation, install the Node.js 7+ and NPM 3+ on a machine
    with internet access.  Package the installed nodejs files and installed modules
    'C:\Users\peek\nodejs'.  Unpackage in the same directory location on the offline
    server.

#.  Python 3.5,

    :Download: `<https://www.python.org/ftp/python/3.5.3/python-3.5.3rc1-amd64.exe>`_
    :From: `<https://www.python.org/downloads/windows/>`_

    #.  Check the 'Add Python 3.5 to PATH' and select 'Customize Installation'

        .. image:: windows_installation_screenshots/Python-Install.jpg

    #.  Update the 'Customize install location' to PATH C:\Users\peek\Python35\

        .. image:: windows_installation_screenshots/Python-AdvancedOptions.jpg

    #.  Confirm PATH(s) to environment variables ::

        C:\Users\peek\Python35\
        C:\Users\peek\Python35\Scripts\

    .. note:: For Offline installation, install Python 3.5 on a machine with internet
    access.  Package the installed python files after synerty-peek package has been
    deployed and configured on the online server.  Package then deploy and unpackage in
     the same directory locations on the offline server.

#.  FreeTDS,

    :Download: `<https://github.com/ramiro/freetds/releases/download/v0.95.95/freetds-v0.95.95-win-x86_64-vs2015.zip>`_
    :From: `<https://github.com/ramiro/freetds/releases>`_

    #.  Unzip contents into ::

        C:\Users\peek\freetds-v0.95.95

    #.  Add PATH to environment variables ::

        C:\Users\peek\freetds-v0.95.95\bin

    #.  Create 'freetds.conf' in "C:\" ::

            [global]
                port = 1433
                instance = peek
                tds version = 7.0
                dump file = /tmp/freetds.log



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

        .. image:: windows_installation_screenshots/GIT-ExtraOptions.jpg

    #.  Add PATH to environment variables ::

            C:\Program Files\Git\bin

#.  Upgrade pip, run the command prompt as Administrator and run the following command: ::

        python -m pip install --upgrade pip

#.  Shapely,

    :Download: `<http://www.lfd.uci.edu/~gohlke/pythonlibs/#shapely>`_
    :From: `<https://pypi.python.org/pypi/Shapely>`_

    #.  Download Shapely >= 1.5.17 and save in the Downloads directory

    #.  Run the command prompt as Administrator and start the bash shell.  Run the
    following command: ::

            pip install ~/Downloads/Shapely-1.5.17-cp35-cp35m-win_amd64.whl

Installing Oracle Libraries (Optional)
``````````````````````````````````````

The oracle libraries are optional. Install them where the agent runs if you are going
to interface with an oracle database.

#.  Install Oracle Instant Client

    :Download: `<http://download.oracle.com/otn/nt/instantclient/121020/instantclient-basic-windows.x64-12.1.0.2.0.zip>`_
    :From: `<http://www.oracle.com/technetwork/topics/winx64soft-089540.html>`_

    Unzip contents into ::

            C:\Users\peek\Oracle\12.1.0.2.0\

    Add 'ORACLE_HOME' to the environment variables and set the path ::

            C:\Users\peek\Oracle\12.1.0.2.0\instantclient_12_1

    Add to the 'PATH' to environment variables ::

            C:\Users\peek\Oracle\12.1.0.2.0\instantclient_12_1

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

#.  Test cx_Oracle with Alchemy (after installing peek) ::

        >>>
        >>> from sqlalchemy import create_engine

        >>> create_engine('oracle://username:password@hostname:1521/instance')
        >>> engine = create_engine('oracle://enmac:bford@192.168.215.128:1521/enmac')
        >>> engine.execute("SELECT 1")

#.  Install and Configure RabbitMQ

    #.  Install Erlang OTP
        :Download: `<http://www.erlang.org/download/otp_win64_19.2.exe>`_
        :From: `<http://www.erlang.org/downloads>`_

    #.  Install rabbitmq
        :Download: `<http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-3.6.6.exe>`_
        :From: `<http://www.rabbitmq.com/download.html>`_


    #.  TODO:

#.  Install and Configure Redis

    :Download: `<http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.6/rabbitmq-server-3.6.6.exe>`_
    :From: `<http://www.rabbitmq.com/download.html>`_

    #.  TODO:

SymLinks
````````

Enabling SymLinks.

.. Note:: This setting has no effect on user accounts that belong to the Administrators
    group.  Those users will always have to run mklink in an elevated environment as
    Administrator.

#.  Launch: "gpedit.msc"

    #.  Navigate: "Computer configuration → Windows Settings → Security Settings → Local
    Policies → User Rights Assignment → Create symbolic links"

        .. image:: windows_installation_screenshots/gpedit-CreateSymlink.jpg

    #.  Add the user or group that you want to allow to create symbolic links

        .. image:: windows_installation_screenshots/gpedit-AddUser.jpg

    #.  You will need to logout and log back in for the change to take effect

`<https://github.com/git-for-windows/git/wiki/Symbolic-Links>`_

Installing synerty-peek
```````````````````````

.. note:: If offline installation is required, complete the Installing synerty-peek
    setup then return to the Offline Installation Guide.

From here you will be deploying either the **Windows Production Platform Setup**
(ProductionSetupWindows.rst) or the **Windows Development Setup**
(DevelopmentSetupWindows.rst).

Offline Installation
--------------------

.. warning:: For offline installation, complete the Online Installation on another
    online server first.  This is because some software requires internet access to
    install.

Software Requirements
`````````````````````

The offline installation guide requires the steps below to be completed after the
Installation has been copied from the online machine to the offline machine:

#.  Refreshing symbolic links::

        $ cd `dirname $(which python)`/lib/site-packages/

        $ rm -r peek_server_fe/src/app/peek_plugin* peek_server_fe/node_modules/peek_plugin*

        $ rm -r peek_client_fe/src/app/peek_plugin* peek_client_fe/node_modules/peek_plugin*

