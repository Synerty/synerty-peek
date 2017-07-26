===========================
Setup OS Requirements MacOS
===========================

This section describes how to perform the setup for MacOS (previosly OSX).

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


*   Python 3.6.x

*   Postgres 9.5

Suggested Software
``````````````````

The following utilities are often useful.

*   rsync

*   git

*   unzip


Optional Software
`````````````````

- Oracle 12c Client

Installing Oracle Libraries is required if you intend on installing the peek agent.
Instruction for installing the Oracle Libraries are in the Online Installation Guide.

- FreeTDS

FreeTDS is an open source driver for the TDS protocol, this is the protocol used to
talk to the MSSQL SQLServer database.

Installation Guide
------------------

Follow the remaining section in this document to prepare your debian operating system for
to run the Peek Platform.

The instructions on this page don't install the peek platform, that's done later.






TODO Installing General Prerequisites
-------------------------------------

This section installs the OS packages required.

.. note:: Run the commands in this step as the :code:`peek` user.

----

Install C libraries that some python packages link to when they install:

::

        PKG=""

        # For the cryptography package
        PKG="$PKG libffi-dev"

        # For the python Samba client
        PKG="$PKG samba-dev libsmbclient-dev libcups2-dev"

        # For Shapely and GEOAlchemy
        PKG="$PKG libgeos-dev libgeos-c1"

        # For LXML and the Oracle client
        PKG="$PKG libxml2 libxml2-dev"
        PKG="$PKG libxslt1.1 libxslt1-dev"

        # For the PostGresQL connector
        PKG="$PKG libpq-dev"

        # For the SQLite python connector
        PKG="$PKG libsqlite3-dev"
        PKG="$PKG libsqlite3-dev"

        sudo apt-get install -y $PKG

----

Install rsync and git packages:

::

        PKG="rsync git unzip"
        sudo apt-get install -y $PKG

----

Cleanup the downloaded packages ::

        sudo apt-get clean




Install Python 3.6
------------------

----

Setup paths

----

Download and install
https://www.python.org/ftp/python/3.6.2/python-3.6.2-macosx10.6.pkg

----

Edit **~/.bash_profile** and insert the following after the first block comment.

Make sure these are before any lines like: ::

        # If not running interactively, don't do anything

Insert : ::

        ##### SET THE PEEK ENVIRONMENT #####
        # Setup the variables for PYTHON
        export PEEK_PY_VER="3.6.1"

        # Set the variables for the platform release
        # These are updated by the deploy script
        export PEEK_ENV=""
        export PATH="${PEEK_ENV}/bin:$PATH"

----

Close and re-open the terminal.

----

Symlink the python3 commands so they are the only ones picked up by path. ::

        cd /Library/Frameworks/Python.framework/Versions/3.6/bin
        ln -s python3 python

----

Test that the setup is working ::

        which python
        echo "It should be /Library/Frameworks/Python.framework/Versions/3.6/bin/python"

        which pip
        echo "It should be /Library/Frameworks/Python.framework/Versions/3.6/bin/pip"

----

synerty-peek is deployed into python virtual environments.
Install the virtualenv python package ::

        pip install virtualenv


----

The Wheel package is required for building platform and plugin releases ::

        pip install wheel


Install PostGreSQL
------------------

Install the relational database we use on Linux.

.. note:: Run the commands in this step as the :code:`peek` user.

Add the latest PostGreSQL repository ::

        F=/etc/apt/sources.list.d/postgresql.list
        echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" | sudo tee $F
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
        sudo apt-get update


----

Install PostGresQL ::

        sudo apt-get install -y postgis postgresql-9.5
        sudo apt-get clean


----

Create the peek SQL user ::

        F=/etc/postgresql/9.5/main/pg_hba.conf
        if ! sudo grep -q 'peek' $F; then
            echo "host  peek    peek    127.0.0.1/32    trust" | sudo tee $F -a
        fi
        sudo su - postgres
        createuser -d -r -s peek
        exit # Exit postgres user


----

Create the database ::

        createdb -O peek peek


----

Set the database password ::

        psql <<EOF
        \password
        \q
        EOF

        # Set the password as "PASSWORD"


----

Cleanup traces of the password ::

        [ -e ~/.psql_history ] && rm ~/.psql_history


Install Oracle Client (Optional)
--------------------------------

The oracle libraries are optional. Install them where the agent runs if you are going to
interface with an oracle database.

----

Edit :file:`~/.bashrc` and insert the following after the first block comment

Make sure these are before any lines like: ::

        # If not running interactively, don't do anything

Insert : ::

        # Setup the variables for ORACLE
        export LD_LIBRARY_PATH="/home/peek/oracle/instantclient_12_2:$LD_LIBRARY_PATH"
        export ORACLE_HOME="/home/peek/oracle/instantclient_12_2"


----

Make the directory where the oracle client will live ::

        mkdir /home/peek/oracle

----

Download the following from oracle.

The version used in these instructions is **12.2.0.1.0**.

#.  Download the "Instant Client Package - Basic" from
    http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

#.  Download the "Instant Client Package - SDK" from
    http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

Copy these files to :file:`/home/peek/oracle` on the peek server.

----

Extract the files. ::

        cd ~/oracle
        unzip instantclient-sdk-linux.x64-12.2.0.1.0.zip
        unzip instantclient-basic-linux.x64-12.2.0.1.0.zip


----

Symlink the oracle client lib ::

        cd $ORACLE_HOME
        ln -snf libclntsh.so.12.1 libclntsh.so
        ls -l libclntsh.so


FreeTDS (Optional)
------------------

FreeTDS is an open source driver for the TDS protocol, this is the protocol used to
talk to the MSSQL SQLServer database.

Peek needs this installed if it uses the pymssql python database driver,
which depends on FreeTDS.

----

Edit :file:`~/.bashrc` and insert the following after the first block comment

Make sure these are before any lines like: ::

        # If not running interactively, don't do anything

Insert : ::

        # Setup the variables for FREE TDS
        export LD_LIBRARY_PATH="/home/peek/freetds:$LD_LIBRARY_PATH"

----

Install FreeTDS:

::

        sudo apt-get install freetds-dev


----

Create file :file:`freetds.conf` in :code:`~/freetds` and populate with the following:

::

        [global]
            port = 1433
            instance = peek
            tds version = 7.4
            dump file = /tmp/freetds.log



What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
