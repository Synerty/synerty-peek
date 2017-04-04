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


- Python and Node build dependencies

- Postgres 9.5

Optional Software
`````````````````

- rsync

- Installing Oracle Libraries

Installing Oracle Libraries is required if you intend on installing the peek agent.
Instruction for installing the Oracle Libraries are in the Online Installation Guide.

Installation Guide
------------------

Run all commands from a terminal window remotely via ssh.

Create User
```````````

Create User :code:`peek` with a home of :code:`/home/peek`

Switch to the :code:`root` user:

::

    su -


----

Create the new user, run the following command:

::

        adduser peek


Example:

::

        root@peekServer:/# adduser peek sudo
        Adding user `peek' ...
        Adding new group `peekpeek' (1001) ...
        Adding new user `peek' (1001) with group `peek' ...
        Creating home directory `/home/peek' ...
        Copying files from `/etc/skel' ...
        Enter new UNIX password:
        Retype new UNIX password:
        passwd: password updated successfully
        Changing the user information for peek
        Enter the new value, or press ENTER for the default
            Full Name []:
            Room Number []:
            Work Phone []:
            Home Phone []:
            Other []:
        Is the information correct? [Y/n] y
        root@peekServer:/#


Installing General Prerequisites
````````````````````````````````

.. note:: Run the commands in this step as the :code:`peek` user.

Install the C Compiler package:

::

        PKG="gcc"
        sudo apt-get install -y $PKG


Install the Python and Node build dependencies:

::

        PKG="build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev"
        PKG="$PKG libexpat-dev libncurses-dev zlib1g-dev libgmp-dev virtualenv"
        sudo apt-get install -y $PKG


Install packages required for the build:

::

        PKG="libbz2-dev libcurl4-gnutls-dev samba-dev libsmbclient-dev libcups2-dev"
        sudo apt-get install -y $PKG


Install packages require for pip installs:

::

        PKG="libxml2"
        PKG="$PKG libxml2-dev"
        PKG="$PKG libxslt1.1"
        PKG="$PKG libxslt1-dev"
        PKG="$PKG libpq-dev"
        PKG="$PKG libsqlite3-dev"
        sudo apt-get install -y $PKG


Install Shapely and GEOAlchemy packages:

::

        PKG="libgeos-dev libgeos-c1"
        sudo apt-get install -y $PKG

Install rsync package, this aren't required but good to have:

::

        PKG="rsync"
        sudo apt-get install -y $PKG



Installing the PostGreSQL database
``````````````````````````````````

Install the relational database we use on Linux.

.. note:: Run the commands in this step as the :code:`peek` user.

Add the latest PostGreSQL repository ::

        F=/etc/apt/sources.list.d/postgresql.list
        echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" | sudo tee $F
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc |
        sudo apt-key add -
        sudo apt-get update


----

Install PostGresQL ::

        sudo apt-get install -y postgis postgresql-9.5


----

Configure the User ::

        F=/etc/postgresql/9.5/main/pg_hba.conf
        if ! sudo grep -q 'peek' $F; then
            echo "host  peek    peek    127.0.0.1/32    trust" | sudo tee $F -a
        fi
        sudo su - postgres
        createuser -d -r -s peek


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

        [ -e ~/.psql_history ] && rm ~/.psql_history || true
        exit


Installing Oracle Libraries (Optional)
``````````````````````````````````````

.. note:: Run the commands in this step as the :code:`peek` user.

The oracle libraries are optional. Install them where the agent runs if you are going to
interface with an oracle database.

Install the OS dependencies for Oracle Instant Client ::

        sudo apt-get install -y libaio1


----

Make the directory where the oracle client will live ::

        cd ~
        PEEK_PY_VER="3.5.2"
        ORACLE_DIR="/home/peek/oracle"
        echo "Oracle client dir will be $ORACLE_DIR"
        mkdir -p $ORACLE_DIR && cd $ORACLE_DIR


----

Download the full oracle client.
    The version used in these instructions is :file:`12.2.0.1.0`.
    Copy into the directory created in the step above.

    - Download:
    `Oracle Database 12c Release 2 Client (12.2.0.1.0) for Linux 64 <http://download.oracle.com/otn/linux/oracle12c/122010/linuxx64_12201_client.zip>`_

    Unpackage in the :file:`ORACLE_DIR`:

::

        unzip linuxamd64_12102_client.zip


What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
