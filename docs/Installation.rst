==================
Installation Guide
==================

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

    Install to PATH "%USERPROFILE%\Python35\"

    Add PATH(s) to environment variables ::

        "%USERPROFILE%\Python35\"
        "%USERPROFILE%\Python35\Scripts\"

#.  FreeTDS,

    :Download: `<https://github.com/ramiro/freetds/releases/download/v0.95.95/freetds-v0.95.95-win-x86_64-vs2015.zip>`_
    :From: `<https://github.com/ramiro/freetds/releases>`_

    Unzip contents into ::

        "%USERPROFILE%\freetds-v0.95.95"

    Add PATH to environment variables ::

        "%USERPROFILE%\freetds-v0.95.95\bin"

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

Installing synerty-peek
```````````````````````

From here you will be deploying either the **Production Platform** (ProductionSetup.rst)
or the **Development Setup** (DevelopmentSetup.rst).

Debian Linux
------------

This section desribes how to perform the setup for Debian Linux 8
The python environment will be installed under the user Peek will run as. This should be
**peek** with a home of **/home/peek**

Installing General Prerequisites
````````````````````````````````
#.  Install the general OS packages ::

        # Python and Node build dependencies
        PKG="gcc"

        # This isn't a dependency, but it's good to have
        PKG="$PKG rsync"
        PKG="$PKG git"

        # For licencing and upgrades
        PKG="$PKG sudo"

        apt-get install -y $PKG

Installing the PostGreSQL database
``````````````````````````````````
Install the relational database we use on Linux.

#.  Add the latest PostGreSQL repository ::

        F=/etc/apt/sources.list.d/postgresql.list
        echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > $F
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

        apt-get update

#.  Install PostGresQL ::

        # The SQL Server we use on Linux
        apt-get install -y postgis postgresql-9.5

#.  Configure the DB and User ::

        PEEK_PG_PASS="PASSWORD"
        F=/etc/postgresql/9.5/main/pg_hba.conf

        if ! grep -q 'peek' $F; then
            echo "host  peek    peek    127.0.0.1/32    trust" >> $F
        fi

        su - postgres
        createuser -d -r -s peek

        # Create the db
        createdb -O peek peek

        # Set the password
        psql <<EOF
        alter role peek password "${PEEK_PG_PASS}";
        \q
        EOF

        # Cleanup traces of the password
        [ -e ~/.psql_history ] && rm ~/.psql_history || true
        exit #su

Setting the Environment
```````````````````````

NOTE: This is done before the software is installed.

#.  Edit **~/.bashrc** and insert the following after the first block comment.
    :NOTE: Make sure these are before any lines like:
    # If not running interactively, don't do anything ::

        ##### SET THE PEEK ENVIRONMENT #####
        export PEEK_PY_VER="3.5.2"
        export PEEK_NODE_VER="7.1.0"
        export LD_LIBRARY_PATH="/home/peek/cpython-${PEEK_PY_VER}/oracle/instantclient_12_1:$LD_LIBRARY_PATH"
        export ORACLE_HOME="/home/peek/cpython-${PEEK_PY_VER}/oracle/instantclient_12_1"
        export PATH="/home/peek/cpython-${PEEK_PY_VER}/bin:/home/peek/node-v${PEEK_NODE_VER}/bin:$PATH"

Compiling and Installing NodeJS
```````````````````````````````

#.  Install the build prerequisites ::

        PKGS="build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev"
        PKGS="$PKGS libexpat-dev libncurses-dev zlib1g-dev libgmp-dev"
        apt-get install $PKGS

#.  Download the supported node version ::

        PEEK_NODE_VER="7.1.0"
        mkdir ~/node_src &&  cd ~/node_src

        wget "https://nodejs.org/dist/v${PEEK_NODE_VER}/node-v${PEEK_NODE_VER}-linux-x64.tar.xz"
        tar xvJf node-v${PEEK_NODE_VER}-linux-x64.tar.xz
        cd node-v${PEEK_NODE_VER}-linux-x64

#.  Configure the NodeJS Build ::

        ./configure --prefix=/home/peek/node-v${PEEK_NODE_VER}
        make -j4 && make install

#.  Test that the setup is working ::

        which node
        echo "It should be /home/peek/node-v7.1.0/bin/node"

        which npm
        echo "It should be /home/peek/node-v7.1.0/bin/npm"

#.  Install the required NPM packages ::

        npm -g upgrade npm
        npm -g install angular-cli typescript tslint

Compiling and Installing Python
```````````````````````````````

#.  Install the required debian packages ::

        # Required for the build
        PKG="libbz2-dev libcurl4-gnutls-dev samba-dev libsmbclient-dev libcups2-dev"

        # Required for pip installs
        PKG="$PKG libxml2"
        PKG="$PKG libxml2-dev"
        PKG="$PKG libxslt1.1"
        PKG="$PKG libxslt1-dev"
        PKG="$PKG libpq-dev"
        PKG="$PKG libsqlite3-dev"

        # For Shapely / GEOAlchemy
        PKG="$PKG libgeos-dev libgeos-c1"

        apt-get install -y $PKG

#.  Download and unarchive the supported version of Python ::

        cd ~
        PEEK_PY_VER="3.5.2"
        wget "https://www.python.org/ftp/python/${PEEK_PY_VER}/Python-${PEEK_PY_VER}.tgz"
        tar xf Python-${PEEK_PY_VER}.tgz

#.  Configure the build ::

        cd Python-${VER}
        ./configure --prefix=/home/peek/cpython-${PEEK_PY_VER}/ --enable-optimizations

#.  Make and Make install the software ::

        make -j4 && make install

#.  Test that the setup is working ::

        which python
        echo "It should be /home/peek/cpython-3.5.2/bin/python"

        which pip
        echo "It should be /home/peek/cpython-3.5.2/bin/pip"

Installing Oracle Libraries (Optional)
``````````````````````````````````````

The oracle libraries are optional. Install them where the agent runs if you are going to
interface with an oracle database.

#.  Install the OS dependencies ::

        # For oracle instant client
        apt-get install -y libaio1

#.  Make the directory where the oracle client will live ::

        ORACLE_DIR="/home/peek/cpython-${PEEK_PY_VER}/oracle"
        echo "Oracle client dir will be $ORACLE_DIR"
        mkdir $ORACLE_DIR && cd $ORACLE_DIR

#.  Download the following from oracle.
    The version used in these instructions is **12.1.0.2.0**.
    Copy them to the directory created in the step above.

    #.  Download the "Instant Client Package - Basic" from
        http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

    #.  Download the "Instant Client Package - SDK" from
        http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

#.  Symlink the oracle client lib ::

        cd $ORACLE_HOME
        ln -snf libclntsh.so.12.1 libclntsh.so
        ls -l libclntsh.so

#.  Now you can install the cx_Oracle python package. ::

        pip install cx_Oracle

#.  Now test it with some python ::

        from sqlalchemy import create_engine
        from sqlalchemy import schema

        orapass = "PASS"
        orahost = "host"

        oraEngine = create_engine('oracle://enmac:%s@%s:1521/NMS' % (orapass, orahost))
        metadata = schema.MetaData(oraEngine)
        metadata.reflect(schema='ENMAC')

        "ENMAC.host_details" in metadata.tables

