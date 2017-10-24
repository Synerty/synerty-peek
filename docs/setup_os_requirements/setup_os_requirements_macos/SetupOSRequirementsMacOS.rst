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

*   Homebrew

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


Create Peek Platform OS User
----------------------------

Alternatively to creating a :code:`peek` user, if you are developing with peek you 
might want to Symlink the :code:`/Users/*developerAccount*` to :code:`/Users/peek`.  
If doing this run: :code:`sudo ln -s /Users/*developerAccount*/ /Users/peek` then 
skip to the next step :ref:`installing_xcode`.

Create a user account for :code:`peek` with admin rights.


----

:Account Type: Administrator
:Username: peek
:Password: PA$$W0RD

----

Sign in to the peek account.

.. important:: All steps after this point assume you're logged in as the peek user.

.. _installing_xcode:

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

        xcode-select --install


----

A popup will appear, select 'Install' then 'Agree' to the license.

----

Agree to the Xcode license in Terminal run: ::

        sudo xcodebuild -license


Type :code:`q`, type :code:`agree` and hit 'Enter'


Install an Oracle JDK
---------------------

Download the macOS disk image:

http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html


Homebrew
--------

To install Homebrew, run the following command in terminal: ::

        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


Install XQuartz
---------------

Download the disk image and install XQuartz:

https://dl.bintray.com/xquartz/downloads/XQuartz-2.7.11.dmg


.. note:: After installing XQuartz you will need to restart terminal.


Install Python 3.6
------------------

In terminal run: ::

        brew install python3


----

Symlink the python3 commands so they are the only ones picked up by path. ::

        cd /usr/local/Cellar/python3/3.6.3/bin/
        ln -s python3 python
        ln -s pip3 pip
        ln -s wheel3 wheel
        cd


----

Edit :file:`~/.bash_profile` and insert the following: ::

        #### SET THE HOMEBREW PYTHON ENVIRONMENT ####
        # Set PATH to include python
        export PATH="/usr/local/Cellar/python3/3.6.3/bin:$PATH"

        ##### SET THE PEEK ENVIRONMENT #####
        # Setup the variables for PYTHON
        export PEEK_PY_VER="3.6.3"

        # Set the variables for the platform release
        # These are updated by the deploy script
        export PEEK_ENV=""
        export PATH="${PEEK_ENV}/bin:$PATH"


----

Open a new terminal and test that the setup is working ::

        which python 
        
        echo "It should be /usr/local/Cellar/python3/3.6.3/bin/python"

        python --version 
        
        echo "It should be Python 3.6.3"

        which pip 
        
        echo "It should be /usr/local/Cellar/python3/3.6.3/bin/pip"

        pip --version 
        
        echo "It should be pip 9.0.1 from /usr/local/lib/python3.6/site-packages (python 3.6)"


----

synerty-peek is deployed into python virtual environments.

Install the virtualenv python package ::

        pip install virtualenv


----

Install the dev libs that the python packages will need to compile ::

        brew install openssl@1.1


Install Worker Dependencies
---------------------------

Install the parallel processing queue we use for the peek-worker tasks.


Redis
`````

Install Redis via Homebrew with the following command: ::

        brew install redis


----

Start redis and create a start at login launchd service: ::

        brew services start redis


----

Open new terminal and test that Redis setup is working ::

        which redis-server 
        
        echo "It should be /usr/local/bin/redis-server"


RabbitMQ
````````

Install RabbitMQ via Homebrew with the following command: ::

        brew install rabbitmq


----

Start rabbitmq and create a start at login launchd service: ::

        brew services start rabbitmq


----

Edit :file:`~/.bash_profile` and insert the following: ::

        ##### SET THE RabbitMQ ENVIRONMENT #####
        # Set PATH to include RabbitMQ
        export PATH="/usr/local/sbin:$PATH"


----

Open new terminal and test that RabbitMQ setup is working ::

        which rabbitmq-server 
        
        echo "It should be /usr/local/sbin/rabbitmq-server"


----

Enable the RabbitMQ management plugins: ::

        rabbitmq-plugins enable rabbitmq_mqtt
        rabbitmq-plugins enable rabbitmq_management


Install PostGreSQL
------------------

Install the relational database we use on macOS.

In terminal run: ::

        brew install postgresql


----

Start postgresql and create start at login launchd service: ::

        brew services start postgresql


----

Update the PostGreSQL unix user auth config: ::

        F=/usr/local/var/postgres/pg_hba.conf
        cat | sudo tee $F <<EOF
        # TYPE  DATABASE        USER            ADDRESS                 METHOD
        local   all             postgres                                peer
        local   all             peek                                    trust

        # "local" is for Unix domain socket connections only
        local   all             all                                     peer
        # IPv4 local connections:
        host    all             all             127.0.0.1/32            md5
        # IPv6 local connections:
        host    all             all             ::1/128                 md5
        EOF


----

Create Postgres user ::

        createuser -d -r -s peek


----

Create the database ::

        createdb -O peek peek


----

Set the database password ::

        psql -d peek -U peek <<EOF
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

The version used in these instructions is :code:`12.1.0.2.0`.

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

Add links to $HOME/lib to enable applications to find the libraries: ::

        mkdir ~/lib
        ln -s ~/oracle/instantclient_12_1/libclntsh.dylib ~/lib/


----

Edit :file:`~/.bash_profile` and insert the following: ::

        ##### SET THE ORACLE ENVIRONMENT #####
        # Set PATH to include oracle
        export ORACLE_HOME="`echo ~/oracle/instantclient_12_1`"
        export PATH="$ORACLE_HOME:$PATH"

        ##### SET THE DYLD_LIBRARY_PATH #####
        export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:$ORACLE_HOME"



FreeTDS (Optional)
------------------

FreeTDS is an open source driver for the TDS protocol, this is the protocol used to
talk to the MSSQL SQLServer database.

Peek needs this installed if it uses the pymssql python database driver,
which depends on FreeTDS.

----

Install FreeTDS via Homebrew: ::

        brew install freetds@0.91
        brew link --force freetds@0.91


----

Edit :file:`~/.bash_profile` and insert the following: ::

        ##### SET THE FINK ENVIRONMENT #####
        # Set PATH to include fink
        export PATH="/usr/local/opt/freetds@0.91/bin:$PATH"


----

Confirm the installation ::

        tsql -C

You should see something similar to: ::

        Compile-time settings (established with the "configure" script)
                                    Version: freetds v0.91.112
                     freetds.conf directory: /usr/local/Cellar/freetds@0.91/0.91.112/etc
             MS db-lib source compatibility: no
                Sybase binary compatibility: no
                              Thread safety: yes
                              iconv library: yes
                                TDS version: 7.1
                                      iODBC: no
                                   unixodbc: no
                      SSPI "trusted" logins: no
                                   Kerberos: no


Change Open File Limit on macOS
-------------------------------

macOS has a low limit on the maximum number of open files.  This becomes an issue when running node applications.

Run the following commands in terminal: ::

        echo kern.maxfiles=65536 | sudo tee -a /etc/sysctl.conf
        echo kern.maxfilesperproc=65536 | sudo tee -a /etc/sysctl.conf
        sudo sysctl -w kern.maxfiles=65536
        sudo sysctl -w kern.maxfilesperproc=65536


----

Edit :file:`~/.bash_profile` and insert the following: ::

        ##### Open File Limit #####
        ulimit -n 65536 65536


----

Restart the terminal


What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
