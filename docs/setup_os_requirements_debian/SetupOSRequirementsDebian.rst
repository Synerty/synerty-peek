============================
Setup OS Requirements Debian
============================

This section describes how to perform the setup for Debian Linux 8.  The Peek platform
is designed to run on Linux.

Please read through all of the documentation before commencing the installation procedure.

Installation Objective
----------------------

This Installation Guide contains specific Debian Linux 8 operating system requirements
for the configuring of synerty-peek.

Required Software
`````````````````

Some of the software to be installed requires internet access. For offline installation
some steps are required to be installed on another online server for the files to be
packaged and transferred to the offline server.

Below is a list of all the required software:


- sudo (For licencing and upgrades)

- C Compiler (gcc, Python and Node build dependencies)

- Postgres 9.5

- NodeJS 7.1

- Python 3.5

Optional Software
`````````````````

- rsync

- git

- Installing Oracle Libraries

Installing Oracle Libraries is required if you intend on installing the peek agent.
Instruction for installing the Oracle Libraries are in the Online Installation Guide.

Installation Guide
------------------

Run all commands from a terminal window remotely via ssh.

Create User
```````````

Create User :code:`peek` with a home of :code:`/home/peek`

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


Setting the Environment
```````````````````````

.. important:: This is done before the software is installed.

Edit :file:`~/.bashrc` and insert the following after the first block comment but
before lines like: :code:`# If not running interactively, don't do anything` ::

        export PEEK_PY_VER="3.5.2"
        export PEEK_NODE_VER="7.1.0"
        export LD_LIBRARY_PATH="/home/peek/cpython-${PEEK_PY_VER}/oracle/instantclient_12_1:$LD_LIBRARY_PATH"
        export ORACLE_HOME="/home/peek/cpython-${PEEK_PY_VER}/oracle/instantclient_12_1"
        export PATH="/home/peek/cpython-${PEEK_PY_VER}/bin:/home/peek/node-v${PEEK_NODE_VER}/bin:$PATH"


Here's an example ::

        # ~/.bashrc: executed by bash(1) for non-login shells.
        # see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
        # for examples

        export PEEK_PY_VER="3.5.2"
        export PEEK_NODE_VER="7.1.0"
        export LD_LIBRARY_PATH="/home/peek/cpython-${PEEK_PY_VER}/oracle/instantclient_12_1:$LD_LIBRARY_PATH"
        export ORACLE_HOME="/home/peek/cpython-${PEEK_PY_VER}/oracle/instantclient_12_1"
        export PATH="/home/peek/cpython-${PEEK_PY_VER}/bin:/home/peek/node-v${PEEK_NODE_VER}/bin:$PATH"

        # If not running interactively, don't do anything
        ...


Installing the PostGreSQL database
``````````````````````````````````
Install the relational database we use on Linux.

#. Add the latest PostGreSQL repository ::

        F=/etc/apt/sources.list.d/postgresql.list
        echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > $F
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

        apt-get update

#. Install PostGresQL ::

        apt-get install -y postgis postgresql-9.5

#. Configure the User ::

        F=/etc/postgresql/9.5/main/pg_hba.conf

        if ! grep -q 'peek' $F; then
            echo "host  peek    peek    127.0.0.1/32    trust" >> $F
        fi

        su - postgres
        createuser -d -r -s peek


#. Create the database ::

        createdb -O peek peek


#. Set the database password ::

        psql <<EOF
        \password
        \q
        EOF

        # Set the password as "PASSWORD"


#. Cleanup traces of the password ::

        [ -e ~/.psql_history ] && rm ~/.psql_history || true
        exit


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

        ./configure --prefix=/home/peek/node-v${PEEK_NODE_VER}-linux-x64
        make -j4 && make install


#.  Test that the setup is working ::

        which node
        echo "It should be /home/peek/node-v7.1.0/bin/node"

        which npm
        echo "It should be /home/peek/node-v7.1.0/bin/npm"


#.  Install the required NPM packages ::

        npm -g upgrade npm
        npm -g install @angular/cli typescript tslint


Compiling and Installing Python
```````````````````````````````

#.  Install the required Debian packages ::

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


#.  Symlink the site packages for convenience ::

        ln -s /home/peek/cpython-3.5.2/lib/python3.5/site-packages /home/peek/peek-site-packages


#.  Test that the setup is working ::

        which python
        echo "It should be /home/peek/cpython-3.5.2/bin/python"

        which pip
        echo "It should be /home/peek/cpython-3.5.2/bin/pip"


Installing Oracle Libraries (Optional)
``````````````````````````````````````

The oracle libraries are optional. Install them where the agent runs if you are going to
interface with an oracle database.

#.  Install the OS dependencies for Oracle Instant Client ::

        apt-get install -y libaio1


#.  Make the directory where the oracle client will live ::

        ORACLE_DIR="/home/peek/cpython-${PEEK_PY_VER}/oracle"
        echo "Oracle client dir will be $ORACLE_DIR"
        mkdir $ORACLE_DIR && cd $ORACLE_DIR


#.  Download the following from oracle.
    The version used in these instructions is :file:`12.1.0.2.0`.
    Copy them to the directory created in the step above.

    - Download the
    `Instant Client Package - Basic <http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html>`_

    - Download the
    `Instant Client Package - SDK <http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html>`_

#.  Symlink the oracle client lib ::

        cd $ORACLE_HOME
        ln -snf libclntsh.so.12.1 libclntsh.so
        ls -l libclntsh.so


#.  Now you can install the cx_Oracle python package ::

        pip install cx_Oracle


#.  Now test it with some python ::

        import cx_Oracle
        con = cx_Oracle.connect('username/password@hostname/instance')
        print con.version
        # Expcect to see "12.1.0.2.0"
        con.close()


