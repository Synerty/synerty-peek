.. _setup_os_requirements_debian:

============================
Setup OS Requirements Debian
============================

This section describes how to perform the setup for Debian Linux 10.  The Peek platform
is designed to run on Linux.

Please read through all of the documentation before commencing the installation procedure.

.. note:: These instructions are for Debian 10, AKA Buster

Installation Objective
----------------------

This Installation Guide contains specific Debian Linux 10 operating system requirements
for the configuring of synerty-peek.

Required Software
`````````````````

Some of the software to be installed requires internet access. For offline installation
some steps are required to be installed on another online server for the files to be
packaged and transferred to the offline server.

Below is a list of all the required software:


*   Python 3.9.x

*   Postgres 12.x

Suggested Software
``````````````````

The following utilities are often useful.

*   rsync

*   git

*   unzip


Optional Software
`````````````````

- Oracle Client

Installing Oracle Libraries is required if you intend on installing the peek agent.
Instruction for installing the Oracle Libraries are in the Online Installation Guide.

- FreeTDS

FreeTDS is an open source driver for the TDS protocol, this is the protocol used to
talk to the MSSQL SQLServer database.

.. _debian_install_prerequisites:

Installation Guide
------------------

Follow the remaining section in this document to prepare your debian operating system for
to run the Peek Platform.

The instructions on this page don't install the peek platform, that's done later.

Install Debian 10 OS
--------------------

This section installs the Debian 10 64bit Linux operating system.


Create VM
`````````

Create a new virtual machine with the following specifications

*   4 CPUs
*   8gb of ram
*   60gb of disk space

Install OS
``````````

Download the debian ISO, navigate to the following site and click **amd64** under
**netinst CD image**

`Download Debian <https://www.debian.org/releases/jessie/debian-installer/>`_

----

Mount the ISO in the virtual machine and start the virtual machine.

Run through the installer manually, do not let your virtual machine software perform
a wizard or express install.

Staring Off
~~~~~~~~~~~

At the **Debian GNU/Linux installer boot menu** screen, select: ::

    Install

----

At the **Select a language** screen, select: ::

    English

----

At the **Select your location** screen, select the appropriate location.

----

At the **Configure the keyboard** screen, select the appropriate keyboard,
or leave as default.

----

At the **Configure the network** screen, enter your desired hostname or: ::

    peek

----

At the **Configure the network** screen, enter your desired domain, or: ::

    localdomain

----

At the **Setup users and passwords screen**, watch for the following prompts,
replace <root_password> and <peek_password> with your desired passwords.

.. csv-table:: Setup users and passwords screen prompts
    :header: "Prompt", "Enter :"
    :widths: auto

    "Root password", "<root_password>"
    "Re-enter password to verify", "<root_password>"
    "Full name for the new user", "Peek Platform"
    "Username for your account", "peek"
    "Choose a password for the new user:", "<peek_password>"
    "Re-enter password to verify:", "<peek_password>"

----

On the **Configure the clock** screen, select your desired timezone.

----

Partition Table
~~~~~~~~~~~~~~~

On the **Partition disks** screen, select: ::

    Manual

Then, select the disk, it will look similar to: ::

    SCSI3 (0,0,0) (sda) - 32.2 GB VMware ...

Then it will prompt to **Create new empty partition table on this device?**,
select: ::

    <Yes>

We'll be creating three partitions, /boot / and swap. For a heavily used production
server you may want to create more virtual disks and separate out /var, /home, and /tmp.
With one file system per disk.

Having one file system per disk removes the need for the overhead of LVM, and the VM
software can still expand the disk and filesystem as required.

/boot
~~~~~

Select the following disk from the menu: ::

    pri/log **.* GB   FREE SPACE


Enter the following responses to the prompts

.. csv-table:: /boot partition prompts part1
    :header: "Prompt", "Enter :"
    :widths: auto

    "How to user this free space", "Create a new partition"
    "New partition size", "500m"
    "Type for the new partition", "Primary"
    "Location for the new Partition", "Beginning"

At the **Partition Settings** prompt, enter the following:

.. csv-table:: /boot partition prompts part2
    :header: "Prompt", "Enter :"
    :widths: auto

    "Use as:", "Ext2 file system"
    "Mount point", "/boot"
    "Done setting up the partition", ""


swap
~~~~

Select the following disk from the menu: ::

    pri/log **.* GB   FREE SPACE


Enter the following responses to the prompts

.. csv-table:: swap partition prompts part1
    :header: "Prompt", "Enter :"
    :widths: auto

    "How to user this free space", "Create a new partition"
    "New partition size", "4g"
    "Type for the new partition", "Primary"
    "Location for the new Partition", "Beginning"

At the **Partition Settings** prompt, enter the following:

.. csv-table:: swap partition prompts part2
    :header: "Prompt", "Enter :"
    :widths: auto

    "Use as:", "swap"
    "Done setting up the partition", ""


/ (root)
~~~~~~~~

The root file system is created at the end of the disk, ensuring that if we use the
VM software to expand the virtual disk, this is the file system that will be expanded.

The default guided install doesn't do this.

----

Select the following disk from the menu: ::

    pri/log **.* GB   FREE SPACE


Enter the following responses to the prompts

.. csv-table:: swap partition prompts part1
    :header: "Prompt", "Enter :"
    :widths: auto

    "How to user this free space", "Create a new partition"
    "New partition size", "100%"
    "Type for the new partition", "Primary"
    "Location for the new Partition", "Beginning"

At the **Partition Settings** prompt, enter the following:

.. csv-table:: swap partition prompts part2
    :header: "Prompt", "Enter :"
    :widths: auto

    "Use as", "Ext4 journaling file system"
    "Mount point", "/"
    "Reserved blocks", "1%"
    "Done setting up the partition", ""

----

All done, select: ::

    Finish partitioning and write changes to disk

----

At the **Write the changes to disk?** prompt, Select: ::

    <Yes>


Finishing Up
~~~~~~~~~~~~

On the **Configure the package manager** screen, select the location closest to you.

----

At the **Debian archive mirror**, select your preferred site.

----

At the **HTTP proxy information** prompt, select: ::

    <Continue>

----

The installer will now download the package lists.

----

At the **Configure popularity-contest** screen, select: ::

    <No>

.. note:: It'd be good to select <Yes>, but as Peek is an enterprise platform, it's
            most likely installed behind a corporate firewall.

----

At the **Software selection** screen, select the following, and deselect all the
other options:

*   SSH server
*   standard system utilities

Optionally, select a desktop environment, Peek doesn't require this.
"MATE" is recommended if one is selected.

----

The OS will now install, it will take a while to download and install the packages.

----

At the **Install the GRUB boot loader on a hard disk** screen, select:

    <Yes>

----

At the **Device for boot loader installation** prompt, select: ::

    /dev/sda

----

At the **Finish the installation** screen, select: ::

    <Continue>

----

Deconfigure the Debian ISO from DVD drive in the VM software.

----

The OS installtion is now complete.

SSH Setup
---------

SSH is this documentations method of working with the Peek Debian VM.

SSH clients are availible out of the box with OSX and Linux. There are many options
for windows users, This documentation recommends
`MobaXterm <http://mobaxterm.mobatek.net>`_ is used for windows as it also supports
graphical file copying.

This document assumes users are familair with what is required to use the SSH clients
for connecting to and copying files to the Peek VM.

If this all sounds too much, reinstall the Peek OS with a graphical desktop environment
and use that instead of SSH.

.. note:: You will not be able to login as root via SSH by default.

----

Login to the console of the Peek Debian VM as **root** and install ifconfig
 with the following command: ::

    apt-get install net-tools

----

Run the following command: ::

    ifconfig

Make note of the ipaddress, you will need this to SSH to the VM. The IP addresss will
be under **eth0**, second line, **inet addr**.

----

Install sudo with the following command: ::

    apt-get install sudo

----

Give Peek sudo privielges with the following command: ::

    usermod -a -G sudo peek

----

You must now logout from the root console.

Login as Peek
-------------

Login to the Debian VM as the :code:`peek` user, either via SSH, or the graphical desktop if it's
installed.

.. important:: All steps after this point assume you're logged in as the peek user.

Configure Static IP (Optional)
------------------------------

If this is a production server, it's more than likely that you want to assign a static
IP to the VM, Here is how you do this.

----

Edit file :file:`/etc/network/interfaces`

Find the section: ::

        allow-hotplug eth0
        iface eth0 inet dhcp

Replace it with: ::

        auto eth0
        iface eth0 inet static
            address <IPADDRESS>
            netmask <NETMASK>
            gateway <GATEWAY>

----

Edit the file :file:`/etc/resolv.conf`, and update it.

#.  Replace "localdomain" with your domain
#.  Replace the IP for the :code:`nameserver` with the IP of you DNS.
    For multiple name servers, use multiple :code:`nameserver` lines. ::

        domain localdomain
        search localdomain
        nameserver 172.16.40.2


Installing General Prerequisites
--------------------------------

This section installs the OS packages required.

.. note:: Run the commands in this step as the :code:`peek` user.

----

Install the C Compiler package, used for compiling python or VMWare tools, etc: ::

        PKG="gcc make linux-headers-amd64"
        sudo apt-get install -y $PKG

----

Install some utility packages: ::

        PKG="rsync unzip wget git"

        sudo apt-get install -y $PKG

----

Install the Python build dependencies: ::

        PKG="build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev"
        PKG="$PKG libexpat-dev libncurses-dev zlib1g-dev libgmp-dev libssl-dev"
        sudo apt-get install -y $PKG

----

Install the Postgres build dependencies: ::

        PKG="bison flex"
        PKG="$PKG libreadline-dev python-dev"
        sudo apt-get install -y $PKG

----

Install Libs that some python packages link to when they install: ::

        # For the cryptography package
        PKG="libffi-dev"

        sudo apt-get install -y $PKG

----

Install Libs required for LDAP: ::

        PKG="libsasl2-dev libldap-common libldap2-dev"

        sudo apt-get install -y $PKG

----

Install Libs that database access python packages link to when they install: ::

        # For Shapely and GEOAlchemy
        PKG="libgeos-dev libgeos-c1v5"

        # For the PostGresQL connector
        PKG="$PKG libpq-dev"

        # For the SQLite python connector
        PKG="$PKG libsqlite3-dev"

        sudo apt-get install -y $PKG

----

Install Libs that the oracle client requires: ::

        # For LXML and the Oracle client
        PKG="libxml2 libxml2-dev"
        PKG="$PKG libxslt1.1 libxslt1-dev"
        PKG="$PKG libaio1 libaio-dev"

        sudo apt-get install -y $PKG

----

Cleanup the downloaded packages ::

        sudo apt-get clean


Installing VMWare Tools (Optional)
----------------------------------

This section installs VMWare tools.
The compiler tools have been installed from the section above.

----

In the VMWare software, find the option to install VMWare tools.

----

Mount and unzip the tools ::

        sudo rm -rf /tmp/vmware-*
        sudo mount /dev/sr0 /mnt
        sudo tar xzf /mnt/VM*gz -C /tmp
        sudo umount /mnt

----

Install the tools with the default options ::

        cd /tmp/vmware-tools-distrib
        sudo ./vmware-install.pl -f -d

----

Cleanup the tools install ::

        sudo rm -rf /tmp/vmware-*

----

Reboot the virtual machine. ::

        sudo shutdown -r now

Keep in mind, that if the static IP is not set, the IP address of the VM may change,
causing issues when reconnecting with SSH.

.. _debian_setup_bashrc:

Preparing .bashrc
-----------------

.. warning:: Open :file:`~/.bashrc` insert the following at the start, before: ::

    # If not running interactively, don't do anything

    If you do not place the below code before that line, it will not be parsed.

::

    ##### SET THE PEEK ENVIRONMENT #####
    # Setup the variables for PYTHON and POSTGRESQL
    export PEEK_PY_VER="3.9.1"
    export PEEK_TSDB_VER="1.7.4"
    export PGDATA=~peek/pgdata/12

    export PATH="$HOME/opt/bin:$PATH"
    export LD_LIBRARY_PATH="$HOME/opt/lib:$LD_LIBRARY_PATH"

    # Set the variables for the platform release
    # These are updated by the deploy script
    export PEEK_ENV=""
    [ -n "${PEEK_ENV}" ] && export PATH="${PEEK_ENV}/bin:$PATH"


----

.. warning:: Restart your terminal to get the new environment.


Compile and Install Python 3.9.1
--------------------------------

The Peek Platform runs on Python. These instructions download, compile and install the
latest version of Python.

----

Download and unarchive the supported version of Python: ::

    cd
    source .bashrc
    wget https://github.com/python/cpython/archive/v${PEEK_PY_VER}.zip
    unzip v${PEEK_PY_VER}.zip
    cd cpython-${PEEK_PY_VER}

----


Configure the build: ::

    ./configure --prefix=/home/peek/opt/ --enable-optimizations --enable-shared


----

Make and Make install the software: ::

    make install


----

Cleanup the download and build dir: ::

    cd
    rm -rf cpython-${PEEK_PY_VER}
    rm v${PEEK_PY_VER}.zip


----

Symlink the python3 commands so they are the only ones picked up by path: ::

    cd /home/peek/opt/bin
    ln -s pip3 pip
    ln -s python3 python
    cd

----

Test that the setup is working: ::


    RED='\033[0;31m'
    GREEN='\033[0;32m'
    NC='\033[0m' # No Color

    SHOULD_BE="/home/peek/opt/bin/python"
    if [ `which python` == ${SHOULD_BE} ]
    then
        echo -e "${GREEN}SUCCESS${NC} The python path is right"
    else
        echo -e "${RED}FAIL${NC} The python path is wrong, It should be ${SHOULD_BE}"
    fi

    SHOULD_BE="/home/peek/opt/bin/pip"
    if [ `which pip` == ${SHOULD_BE} ]
    then
        echo -e "${GREEN}SUCCESS${NC} The pip path is right"
    else
        echo -e "${RED}FAIL${NC} The pip path is wrong, It should be ${SHOULD_BE}"
    fi


----

Upgrade pip: ::

    pip install --upgrade pip


----

synerty-peek is deployed into python virtual environments. Install the virtualenv
python package: ::

    pip install virtualenv

----

The Wheel package is required for building platform and plugin releases: ::

    pip install wheel


.. _debian_install_postgresql:

Install PostgreSQL
------------------

Install the relational database Peek stores its data in.
This database is PostgreSQL 12.

.. note:: Run the commands in this step as the :code:`peek` user.

Download the PostgreSQL source code ::

    PEEK_PG_VER=12.5
    SRC_DIR="$HOME/postgresql-${PEEK_PG_VER}"

    # Remove the src dir and install file
    rm -rf ${SRC_DIR} || true
    cd $HOME

    wget https://ftp.postgresql.org/pub/source/v${PEEK_PG_VER}/postgresql-${PEEK_PG_VER}.tar.bz2
    tar xjf postgresql-${PEEK_PG_VER}.tar.bz2

    cd ${SRC_DIR}


----

Configure and build PostGresQL ::

    export CPPFLAGS=" -I`echo $HOME/opt/include/python*m` "
    export LDFLAGS=" -L$HOME/opt/lib "

    ./configure \
          --disable-debug \
          --prefix=$HOME/opt \
          --enable-thread-safety \
          --with-openssl \
          --with-python


    make -j4

    make install-world

    # this is required for timescale to compile
    cp ${SRC_DIR}/src/test/isolation/pg_isolation_regress ~/opt/bin


----

Remove install files to clean up the home directory ::

    # Remove the src dir and install file
    cd
    rm -rf ${SRC_DIR}*

----

Initialise a PostgreSQL database ::

    #Refresh .bashrc so initdb can find postgres
    source .bashrc

    initdb --pgdata=$HOME/pgdata/12 --auth-local=trust  --auth-host=md5


----

Tune the :file:`postgresql.conf` ::

    F="$HOME/pgdata/12/postgresql.conf"

    sed -i 's/max_connections = 100/max_connections = 200/g' $F


----

Make PostgreSQL a service :

.. note:: This will require sudo permissions

Run the following command ::

    touch postgresql-12.service

    F=postgresql-12.service

    cat <<"EOF" | sed "s,\$HOME,`echo ~peek`,g" > $F
    [Unit]
    Description=PostgreSQL 12 database server
    After=syslog.target
    After=network.target

    [Service]
    Type=forking
    User=peek
    Group=peek

    # Location of database directory
    Environment=PGDATA=$HOME/pgdata/12

    # Disable OOM kill on the postmaster
    OOMScoreAdjust=-1000
    Environment=PG_OOM_ADJUST_FILE=/proc/self/oom_score_adj
    Environment=PG_OOM_ADJUST_VALUE=0

    ExecStart=$HOME/opt/bin/pg_ctl -D ${PGDATA} start
    ExecStop=$HOME/opt/bin/pg_ctl -D ${PGDATA} stop
    ExecReload=/bin/kill -HUP $MAINPID
    KillMode=mixed
    KillSignal=SIGINT


    # Do not set any timeout value, so that systemd will not kill postmaster
    # during crash recovery.
    TimeoutSec=0

    [Install]
    WantedBy=multi-user.target
    EOF

    sudo mv $F /etc/systemd/system/postgresql-12.service


----

Reload the daemon ::

    sudo systemctl daemon-reload


Install CMake
`````````````

Download CMake source code::

    PEEK_CMAKE_VER=3.19.2
    SRC_DIR="$HOME/CMake-${PEEK_CMAKE_VER}"
    wget https://github.com/Kitware/CMake/archive/v${PEEK_CMAKE_VER}.zip

    unzip v${PEEK_CMAKE_VER}.zip
    cd ${SRC_DIR}


Compile CMake from source::

    ./configure --prefix=$HOME/opt

    make -j6 install

    # Remove the src dir and install file
    cd
    rm -rf ${SRC_DIR}*
    rm v${PEEK_CMAKE_VER}.zip


Install PostgreSQL Timescaledb
``````````````````````````````

Next install timescaledb, this provides support for storing large amounts of historical
data.

`www.timescale.com <https://www.timescale.com>`_

----

Download the timescaledb source code ::

    PEEK_TSDB_VER=1.7.4

    cd
    wget https://github.com/timescale/timescaledb/archive/${PEEK_TSDB_VER}.zip
    unzip ${PEEK_TSDB_VER}.zip
    cd timescaledb-${PEEK_TSDB_VER}


----

Install the packages: ::

    export CPPFLAGS=`pg_config --cppflags`
    export LDFLAGS=`pg_config --ldflags`

    # Bootstrap the build system
    ./bootstrap -DAPACHE_ONLY=1

    # To build the extension
    cd build && make

    # To install
    make install

    # Cleanup the source code
    cd
    rm -rf ${PEEK_TSDB_VER}.zip
    rm -rf timescaledb-${PEEK_TSDB_VER}


----

Add the timescale repository: ::

    curl -s https://packagecloud.io/install/repositories/timescale/timescaledb/script.deb.sh | sudo bash


----

Install timescaledb-tune: ::

    sudo apt install -y timescaledb-tools


----

Tune the database: ::

    PGVER=12
    FILE="$HOME/pgdata/${PGVER}/postgresql.conf"
    timescaledb-tune -quiet -yes -conf-path ${FILE} -pg-version ${PGVER}


----

Start PostgreSQL: ::

    systemctl enable postgresql-12 --now


Finish PostgreSQL Setup
````````````````````````

Finish configuring and starting PostgreSQL.

----

Allow the peek OS user to login to the database as user peek with no password ::

    F=$HOME/pgdata/12/pg_hba.conf
    cat | sudo tee $F <<EOF
    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    local   all             peek                                    trust

    # "local" is for Unix domain socket connections only
    local   all             all                                     peer
    # IPv4 local connections:
    host    all             all             127.0.0.1/32            md5
    # IPv6 local connections:
    host    all             all             ::1/128                 md5
    EOF


----

Create the database: ::

    createdb -O peek peek


----

Set the PostgreSQL peek users password: ::

    psql -d peek -U peek <<EOF
    \password
    \q
    EOF

    # Set the password as "PASSWORD" for development machines
    # Set it to a secure password from https://xkpasswd.net/s/ for production

----

.. note:: If you already have a database, you may now need to upgrade the timescale
          extension. ::

            psql peek <<EOF
            ALTER EXTENSION timescaledb UPDATE;
            EOF

----

Cleanup traces of the password: ::

    [ ! -e ~/.psql_history ] || rm ~/.psql_history


Grant PostgreSQL Peek Permissions
`````````````````````````````````

The PostgreSQL server now runs parts of peeks python code inside
the postgres/postmaster processes. To do this the postgres user
needs access to peeks home directory where the peek software is
installed.

---

Grant permissions ::

    sudo chmod g+rx ~peek


Install Worker Dependencies
---------------------------

Install the parallel processing queue we use for the peek-worker-service tasks.

.. note:: Run the commands in this step as the :code:`peek` user.

Install redis and rabbitmq ::

        sudo apt-get install -y redis-server rabbitmq-server
        sudo apt-get clean

----

Enable the RabbitMQ management plugins: ::

        sudo rabbitmq-plugins enable rabbitmq_mqtt
        sudo rabbitmq-plugins enable rabbitmq_management
        sudo service rabbitmq-server restart


----

Increase the size of the redis client queue ::

        BEFORE="client-output-buffer-limit pubsub 64mb 16mb 90"
        AFTER="client-output-buffer-limit pubsub 32mb 8mb 60"
        sudo sed -i "s/${BEFORE}/${AFTER}/g" /etc/redis/redis.conf

        sudo systemctl restart redis


Install Oracle Client (Optional)
--------------------------------

The oracle libraries are optional. Install them where the agent runs if you are
going to interface with an oracle database.

----

.. warning:: Open :file:`~/.bashrc` insert the following at the start, before: ::

    # If not running interactively, don't do anything

    If you do not place the below code before that line, it will not be parsed.


::

        # Setup the variables for ORACLE
        export LD_LIBRARY_PATH="/home/peek/oracle/instantclient_21_1:$LD_LIBRARY_PATH"
        export ORACLE_HOME="/home/peek/oracle/instantclient_21_1"

----

Source the new profile to get the new variables: ::

        source ~/.bashrc

----

Make the directory where the oracle client will live ::

        mkdir /home/peek/oracle

----

Download the following from oracle.

The version used in these instructions is **21.1.0.0.0**.

#.  Download the ZIP "Basic Package"
    :file:`instantclient-basic-linux.x64-21.1.0.0.0.zip` from
    http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

#.  Download the ZIP "SDK Package"
    :file:`instantclient-sdk-linux.x64-21.1.0.0.0.zip` from
    http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

Copy these files to :file:`/home/peek/oracle` on the peek server.

----

Extract the files. ::

        cd ~/oracle
        unzip instantclient-basic-linux.x64-21.1.0.0.0.zip*
        unzip instantclient-sdk-linux.x64-21.1.0.0.0.zip*


Install FreeTDS (Optional)
--------------------------

FreeTDS is an open source driver for the TDS protocol, this is the protocol used to
talk to a MSSQL SQLServer database.

Peek needs this installed if it uses the pymssql python database driver,
which depends on FreeTDS.

----

.. warning:: Open :file:`~/.bashrc` insert the following at the start, before: ::

    # If not running interactively, don't do anything

    If you do not place the below code before that line, it will not be parsed.


::

        # Setup the variables for FREE TDS
        export LD_LIBRARY_PATH="/home/peek/freetds:$LD_LIBRARY_PATH"

----

.. warning:: Restart your terminal you get the new environment.

----

Install FreeTDS: ::

        sudo apt-get install -y freetds-dev

----

Create file :file:`freetds.conf` in :code:`~/freetds` and populate with the following: ::

        mkdir ~/freetds
        cat > ~/freetds/freetds.conf <<EOF

        [global]
            port = 1433
            instance = peek
            tds version = 7.4

        EOF


If you want to get more debug information, add the dump file line to the [global] section
Keep in mind that the dump file takes a lot of space. ::

        [global]
            port = 1433
            instance = peek
            tds version = 7.4
            dump file = /tmp/freetds.log



What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
