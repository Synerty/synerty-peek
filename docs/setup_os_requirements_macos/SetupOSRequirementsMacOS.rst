.. _setup_os_requirements_macos:

===========================
Setup OS Requirements MacOS
===========================

This section describes how to perform the setup for MacOS (previously OSX).

Please read through all of the documentation before commencing the installation procedure.


Installation Objective
----------------------

This Installation Guide contains specific Mac 10.12 Sierra operating system requirements
for the configuring of synerty-peek.


Required Software
`````````````````

Some of the software to be installed requires internet access. For offline installation
some steps are required to be installed on another online server for the files to be
packaged and transferred to the offline server.

Below is a list of all the required software:

*   Xcode (from the app store)

*   Oracle JDK

*   Fink

*   Python 3.6.x

*   Postgres 9.5


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

Follow the remaining section in this document to prepare your macOS operating system 
to run the Peek Platform.

The instructions on this page don't install the peek platform, that's done later.

.. note:: Run the commands in this step as the :code:`peek` user.


Installing Xcode
----------------

From the app store, install Xcode.

----

Run Xcode and accept 'Agree' to the license.  Xcode will then install components.

----

Exit Xcode

----

Run Terminal

----

Apple's Command Line Developer Tools can be installed on recent OS versions by 
running this command in the Terminal: ::

        sudo xcode-select --install

----

A popup will appear, select 'Install' then 'Agree' to the license.

----

Agree to the Xcode license in Terminal run: ::

        sudo xcodebuild -license

Scroll to the bottom, type 'Agree' and hit 'Enter'


Install an Oracle JDK
---------------------

Download the macOS disk image:

http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html


Install Fink
------------

Download the Fink Source Release

http://downloads.sourceforge.net/fink/fink-0.41.1.tar.gz

----

In the terminal prompt run: ::

        sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
        cd $HOME/Downloads
        tar -xvf fink-0.41.1.tar.gz
        cd fink-0.41.1
        ./bootstrap


Select defaults

----

After installation is completed, run the following command in the terminal: ::

        /sw/bin/pathsetup.sh


----

Download package description files and patches, 
in a new terminal run the following commands: ::

        fink selfupdate-rsync
        fink index -f


Install XQuartz
---------------

Download the disk image and install XQuartz:

https://dl.bintray.com/xquartz/downloads/XQuartz-2.7.11.dmg


.. note:: After installing XQuartz you will need to restart terminal.


TODO Install Python 3.6
------------------

In terminal run: ::

        fink install python36

----

Edit **~/.bash_profile** and insert the following after the first block comment.

Make sure these are before any lines like: ::

        # If not running interactively, don't do anything

Insert : ::

        ##### SET THE FINK ENVIRONMENT #####
        # Set PATH to include fink
        export PATH="/sw/bin:$PATH"

        ##### SET THE PEEK ENVIRONMENT #####
        # Setup the variables for PYTHON
        export PEEK_PY_VER="3.6.2"

        # Set the variables for the platform release
        # These are updated by the deploy script
        export PEEK_ENV=""
        export PATH="${PEEK_ENV}/bin:$PATH"


----

Close and re-open the terminal.

----

Symlink the python3 commands so they are the only ones picked up by path. ::

        cd /sw/bin/
        sudo ln -s python3.6 python

----

In terminal run: ::

        fink install pip-py36

----

Test that the setup is working ::

        which python
        echo "It should be /sw/bin/python"
        
        python --version
        echo "It should be Python 3.6.2"

        which pip
        echo "It should be /sw/bin/pip"

        pip --version
        echo "It should be pip 9.0.1 from /sw/lib/python3.6/site-packages (python 3.6)"


----

synerty-peek is deployed into python virtual environments.

Install the virtualenv python package ::

        sudo pip install virtualenv


----

The Wheel package is required for building platform and plugin releases ::

        sudo pip install wheel


Install PostGreSQL
------------------

Install the relational database we use on macOS.

In terminal run: ::

        fink install postgresql96 postgis95


----

Update the PostGreSQL unix user auth config: ::

        cat | sudo tee $F <<EOF
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             postgres                                peer

        # "local" is for Unix domain socket connections only
        local   all             all                                     peer
        # IPv4 local connections:
        host    all             all             127.0.0.1/32            md5
        # IPv6 local connections:
        host    all             all             ::1/128                 md5
        EOF


----

Create the peek SQL user: ::

        sudo su - postgres

        /sw/bin/pg_ctl start -D /sw/var/postgresql-9.6/data/
        /sw/bin/pg_ctl reload -D /sw/var/postgresql-9.6/data/

        /sw/bin/createuser -d -r -s peek
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

Make the directory where the oracle client will live ::

        mkdir ~/oracle


----

Download the following from oracle.

The version used in these instructions is **12.1.0.2.0**.

.. note:: Oracle version 12.2 is not available for macOS.

#.  Download the "Instant Client Package - Basic" from
    http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html

#.  Download the "Instant Client Package - SDK" from
    http://www.oracle.com/technetwork/topics/intel-macsoft-096467.html

Copy these files to :file:`~/oracle` on the peek server.

----

Extract the files. ::
        
        cd ~/oracle
        unzip instantclient-basic-macos.x64-12.1.0.2.0.zip
        unzip instantclient-sdk-macos.x64-12.1.0.2.0.zip


----

Create the appropriate libclntsh.dylib link for the version of Instant Client: ::

        cd ~/oracle/instantclient_12_1
        ln -s libclntsh.dylib.12.1 libclntsh.dylib


----

Add links to $HOME/lib or /usr/local/lib to enable applications to find the libraries: ::

        mkdir ~/lib
        ln -s ~/instantclient_12_1/libclntsh.dylib ~/lib/


----

Update PATH: ::

        export PATH=~/oracle/instantclient_12_1:$PATH


FreeTDS (Optional)
------------------

FreeTDS is an open source driver for the TDS protocol, this is the protocol used to
talk to the MSSQL SQLServer database.

Peek needs this installed if it uses the pymssql python database driver,
which depends on FreeTDS.

----

Install FreeTDS:

::

        fink install freetds freetds-common freetds-dev


----

Confirm the installation ::

        tsql -C

You should see something similar to: ::

        Compile-time settings (established with the "configure" script)
                                       Version: freetds v0.91
                        freetds.conf directory: /sw/etc/freetds
                MS db-lib source compatibility: no
                   Sybase binary compatibility: yes
                                 Thread safety: yes
                                 iconv library: yes
                                   TDS version: 4.2
                                         iODBC: no
                                      unixodbc: yes
                         SSPI "trusted" logins: no
                                      Kerberos: no


What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
