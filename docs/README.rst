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

#.  Chrome
    :Download: https://www.google.com/intl/en/chrome/browser/desktop/index.html?standalone=1#
    :From: https://www.google.com/chrome/

#.  Python 3.5
    :Download: https://www.python.org/ftp/python/3.5.3/python-3.5.3rc1-amd64.exe
    :From: https://www.python.org/downloads/windows/
    Add PATH to environment variables ::

        "~\AppData\Local\Programs\Python\Python35\Scripts\"
        "~\AppData\Local\Programs\Python\Python35\"


    Confirm PATH with ::

        $ which python

#.  Node.js 7+ and NPM 3+
    :Download: https://nodejs.org/dist/v7.4.0/node-v7.4.0-x64.msi
    :From: https://nodejs.org/en/download/current/
    Add PATH to environment variables ::

        "~\AppData\Roaming\npm"

    Confirm PATH with ::

        $ which NPM

#.  Install the required NPM packages ::

    npm -g upgrade npm
    npm -g install angular-cli typescript tslint

#. GitBash
    :Download: https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.1/Git-2.11.0-64-bit.exe
    :From: https://git-for-windows.github.io
    Add PATH to environment variables ::

        "C:\Program Files\Git\bin"

#.  FreeTDS
    :Download: https://github.com/ramiro/freetds/releases/download/v0.95.95/freetds-v0.95.95-win-x86_64-vs2015.zip
    :From: https://github.com/ramiro/freetds/releases
    Unzip contents into ::

        "~\AppData\Local\Programs\Python\Python35\freetds-v0.95.95"

    Add PATH to environment variables ::

        "~\AppData\Local\Programs\Python\Python35\freetds-v0.95.95\bin"

    Confirm PATH with ::

        $ which tsql

    Create 'freetds.conf' in "C:\" ::

    [global]
        port = 1433
        instance = ./peek
        tds version = 7.0
        dump file = /tmp/freetds.log
    [custom_config]
        host = localhost
        instance = peek
        port = 1433
        tds version = 7.0
        encryption = reques

-
    :Download: http://indy.fulgan.com/SSL/openssl-1.0.2j-x64_86-win64.zip
    :From: http://indy.fulgan.com/SSL/
    ensure these files are in the system32 folder:
        libeay32.dll
        ssleay32.dll
    You will need to duplicate the above files and name them as per below:
        libeay32MD.dll
        ssleay32MD.dll

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

#.  Microsoft .NET Framework 3.5 Service Pack 1
    :Download: https://www.microsoft.com/en-ca/download/details.aspx?id=22

#.  Visual C++ Build Tools 2015
    :Download: http://go.microsoft.com/fwlink/?LinkId=691126&__hstc=268264337.40d7988155305183930d94960a802559.1481662741421.1481662741421.1484335933816.2&__hssc=268264337.1.1484335933816&__hsfp=1223438833&fixForIE=.exe
    :From: http://landinghub.visualstudio.com/visual-cpp-build-tools

#.  Microsoft® SQL Server® 2014 Express
    :Download: https://www.microsoft.com/en-ca/download/details.aspx?id=42299

    Make Changes in SQL Server Configuration Manager ::


        SQL Server Configuration Manager --> SQL Server Network Configuration --> Protocols for SQLEXPRESS:
            under the TCP/IP properties set 'IPALL' 'TCP PORT' to '1433'. Select 'Apply' then 'OK',
            Enable the 'TCP/IP' Protocol
            Restart the server service.

#.  Visual Studio Code
    :Download: https://code.visualstudio.com
    Add PATH to environment variables ::

        "C:\Program Files (x86)\Microsoft VS Code\bin"

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

#.  In the "Control Panel", Select: "Edit Group Policy"
#.  Navigate: "Computer configuration → Windows Settings → Security Settings → Local
Policies → User Rights Assignment → Create symbolic links"
#.  Add the user or group that you want to allow to create symbolic links
#.  You will need to logout and log back in for the change to take effect

http://superuser.com/questions/104845/permission-to-make-symbolic-links-in-windows-7

PYTHON ENVIRONMENT
------------------

This section describes how to setup the Python environments.

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
    NOTE: Make sure these are before any lines like :
        # If not running interactively, don't do anything
    ::

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

DEVELOPING
----------
For platform development (NOTE: Most development will be for the plugin, not platform,
so these instructions are not high priority)

FROM SHELL
``````````

#.  Checkout the following, all in the same folder

    #.  peek -> rename dir to synerty-peek
    #.  plugin_base
    #.  peek_agent
    #.  peek_client
    #.  peek_client_fe
    #.  peek_platform
    #.  peek_server
    #.  peek_server_fe
    #.  peek_worker

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
    ./uninstall_and_develop.sh


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

Building
````````

The peek package has build scripts that generate a platform build.
It has two modes
#. Prod build, it tags, commits and test uploads to testpypi
#. Dev build, it doesn't tag, commit or test upload, but still generates a build.

::

    # For a dev build
    # NOTE: Omitting the dot before dev will cause the script to fail as setuptools
    # adds the dot in if it's not there, which means the cp commands won't match files.
    ./pipbuild_platform.sh 0.0.1.dev1

    # For a prod build
    ./pipbuild_platform.sh 0.0.8
    ./pypi_upload.sh


