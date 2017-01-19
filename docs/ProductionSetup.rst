========================
Peek Production Platform
========================

This documentation extends Synerty Peek (README.rst).

Windows Support
---------------

The Peek platform is designed to run on Linux, however, it is compatible with windows.
This section describes the requirements and configuration for windows.

Software Requirements
`````````````````````

#.  Create peek user account

    *  Username: peek
    *  Password: PASSWORD
    *  sign in to the peek account

#.  Chrome,

    :Download: `<https://www.google.com/intl/en/chrome/browser/desktop/index.html?standalone=1#>`_
    :From: `<https://www.google.com/chrome/>`_

#.  Microsoft .NET Framework 3.5 Service Pack 1,

    :Download: `<https://www.microsoft.com/en-ca/download/details.aspx?id=22>`_

#.  Visual C++ Build Tools 2015,

    :Download: `<http://go.microsoft.com/fwlink/?LinkId=691126&__hstc=268264337.40d7988155305183930d94960a802559.1481662741421.1481662741421.1484335933816.2&__hssc=268264337.1.1484335933816&__hsfp=1223438833&fixForIE=.exe>`_
    :From: `<http://landinghub.visualstudio.com/visual-cpp-build-tools>`_

#.  Microsoft® SQL Server® 2014 Express,

    :From: `<https://www.microsoft.com/en-ca/download/details.aspx?id=42299>`_

    *  Shared Feature: check 'LocalDB'
    *  Instance Configuration: change the named instance to 'peek'
    *  Server Configuration: enter the Account Name and Password details for the 'peek'
       user.

#.  Make Changes in SQL Server Configuration Manager (SQLServerManager12.msc)

    *  SQL Server Configuration Manager --> SQL Server Network Configuration -->
       Protocols for PEEK:
    *  Under the TCP/IP properties set 'IPALL' 'TCP PORT' to '1433'. Select 'Apply' then
       'OK',
    *  Enable the 'TCP/IP' Protocol
    *  Restart the server service.

#.  Node.js 7+ and NPM 3+,

    :Download: `<https://nodejs.org/dist/v7.4.0/node-v7.4.0-x64.msi>`_
    :From: `<https://nodejs.org/en/download/current/>`_

    Add PATH to environment variables ::

        "%USERPROFILE%\AppData\Roaming\npm"

#.  Install the required NPM packages ::

        npm -g upgrade npm
        npm -g install angular-cli typescript tslint

#.  Python 3.5,

    :Download: `<https://www.python.org/ftp/python/3.5.3/python-3.5.3rc1-amd64.exe>`_
    :From: `<https://www.python.org/downloads/windows/>`_

    Add PATH to environment variables ::

        "%USERPROFILE%\AppData\Local\Programs\Python\Python35\"

#.  FreeTDS,

    :Download: `<https://github.com/ramiro/freetds/releases/download/v0.95.95/freetds-v0.95.95-win-x86_64-vs2015.zip>`_
    :From: `<https://github.com/ramiro/freetds/releases>`_

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

#.  dll files,

    :Download: `<http://indy.fulgan.com/SSL/openssl-1.0.2j-x64_86-win64.zip>`_
    :From: `<http://indy.fulgan.com/SSL/>`_

    *  ensure these files are in the system32 folder:
        *  libeay32.dll
        *  ssleay32.dll

        *  You will need to duplicate the above files and name them as per below:
            *  libeay32MD.dll
            *  ssleay32MD.dll

#. GitBash,

    :Download: `<https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.1/Git-2.11.0-64-bit.exe>`_
    :From: `<https://git-for-windows.github.io>`_

    Configuring Extra Options: check 'Enable Symbolic Links'

    Add PATH to environment variables ::

        "C:\Program Files\Git\bin"

#.  Upgrade pip ::

        python -m pip install --upgrade pip

#.  Shapely,

    :Download: `<http://www.lfd.uci.edu/~gohlke/pythonlibs/#shapely>`_
    :From: `<https://pypi.python.org/pypi/Shapely>`_

    Shapely >= 1.5.17 ::

        pip install ~/Downloads/Shapely-1.5.17-cp35-cp35m-win_amd64.whl

#.  Celery::

        $ pip install celery

#.  Twisted::

        $ pip install twisted

synerty-peek
------------

#.  synerty-peek::

        $ pip install synerty-peek

#.  Install front end packages::

        $ cd `dirname $(which python)`/lib/site-packages/peek_client_fe
        $ npm install

