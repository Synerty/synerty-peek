============================
Setup OS Requirements Debian
============================

This section describes how to perform the setup for Debian Linux 9.  The Peek platform
is designed to run on Linux.

Please read through all of the documentation before commencing the installation procedure.

.. note:: These instructions are for Debian 9, AKA Stretch

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

Installation Guide
------------------

Follow the remaining section in this document to prepare your debian operating system for
to run the Peek Platform.

The instructions on this page don't install the peek platform, that's done later.

Install Debian 8 OS
-------------------

This section installs the Debian 8 64bit Linux operating system.


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

        PKG="rsync unzip wget"

        sudo apt-get install -y $PKG

----

Install the Python build dependencies: ::

        PKG="build-essential curl git m4 ruby texinfo libbz2-dev libcurl4-openssl-dev"
        PKG="$PKG libexpat-dev libncurses-dev zlib1g-dev libgmp-dev libssl-dev"
        sudo apt-get install -y $PKG

----

Install C libraries that some python packages link to when they install: ::

        # For the cryptography package
        PKG="libffi-dev"

        sudo apt-get install -y $PKG

----

Install C libraries required for LDAP: ::

        PKG="libsasl2-dev libldap-common libldap2-dev"

        sudo apt-get install -y $PKG

----

Install C libraries that database access python packages link to when they install: ::

        # For Shapely and GEOAlchemy
        PKG="libgeos-dev libgeos-c1v5"

        # For the PostGresQL connector
        PKG="$PKG libpq-dev"

        # For the SQLite python connector
        PKG="$PKG libsqlite3-dev"

        sudo apt-get install -y $PKG

----

Install C libraries that the oracle client requires: ::

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

.. _debian_install_postgresql:

Install PostgreSQL
------------------

Install the relational database Peek stores its data in.
This is PostgreSQL 10.

.. note:: Run the commands in this step as the :code:`peek` user.

Add the latest PostgreSQL repository ::

        F=/etc/apt/sources.list.d/postgresql.list
        echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" | sudo tee $F
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
        sudo apt-get update


----

Install PostGresQL ::

        sudo apt-get install -y postgresql-12-postgis-2.4 postgresql-12 postgresql-plpython3-12
        sudo apt-get clean


Install PostgreSQL Timescale
````````````````````````````

Next install timescale, this provides support for storing large amounts of historical
data.

`www.timescale.com <https://www.timescale.com>`_

----

Setup the repository. ::

         # Add our repository
         VAL="deb https://packagecloud.io/timescale/timescaledb/debian/ `lsb_release -c -s` main"
         sudo sh -c "echo ${VAL} > /etc/apt/sources.list.d/timescaledb.list"
         wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -

----

Install the packages ::

        # Install any updates to the operating system
        # You may want to skip this step if you don't want to upgrade
        sudo apt-get update

        # Now install appropriate package for PG version
        sudo apt-get install timescaledb-postgresql-12

----

Tune the :file:`postgresql.conf` ::

        PGVER=12
        FILE="/var/lib/pgsql/${PGVER}/data/postgresql.conf"
        sudo timescaledb-tune -quiet -yes -conf-path ${FILE} -pg-version ${PGVER}


Finish PostgreSQL Setup
````````````````````````

Finish configuring and starting PostgreSQL.

----

Allow the peek OS user to login to the database as user peek with no password ::

        F=/etc/postgresql/12/main/pg_hba.conf
        if ! sudo grep -q 'peek' $F; then
            echo "host  peek    peek    127.0.0.1/32    trust" | sudo tee $F -a
        fi

----

Create the PostgreSQL cluster and configure it to auto start: ::

        sudo /usr/pgsql-12/bin/postgresql-12-setup initdb
        sudo systemctl enable postgresql-12
        sudo systemctl start postgresql-12

----

Create the peek SQL user ::

        sudo su - postgres
        createuser -d -r -s peek
        exit # Exit postgres user


----

Set the PostgreSQL peek users password ::

        psql -d postgres -U peek <<EOF
        \password
        \q
        EOF

        # Set the password as "PASSWORD" for development machines
        # Set it to a secure password from https://xkpasswd.net/s/ for production

----

Create the database ::

        createdb -O peek peek

.. note:: If you already have a database, you may now need to upgrade the timescale
          extension. ::

                psql peek <<EOF
                ALTER EXTENSION timescaledb UPDATE;
                EOF

----

Cleanup traces of the password ::

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
        sudo usermod -G peek postgres

Compile and Install Python 3.6
------------------------------

The Peek Platform runs on Python. These instructions download, compile and install the
latest version of Python.

----

Edit **~/.bashrc** and insert the following after the first block comment.

Make sure these are before any lines like: ::

        # If not running interactively, don't do anything

Insert : ::

        ##### SET THE PEEK ENVIRONMENT #####
        # Setup the variables for PYTHON
        export PEEK_PY_VER="3.6.8"
        export PATH="/home/peek/cpython-${PEEK_PY_VER}/bin:$PATH"

        # Set the variables for the platform release
        # These are updated by the deploy script
        export PEEK_ENV=""
        [ -n "${PEEK_ENV}" ] && export PATH="${PEEK_ENV}/bin:$PATH"

----

.. warning:: Restart your terminal you get the new environment.

----

Download and unarchive the supported version of Python ::

        cd ~
        source .bashrc
        wget "https://www.python.org/ftp/python/${PEEK_PY_VER}/Python-${PEEK_PY_VER}.tgz"
        tar xzf Python-${PEEK_PY_VER}.tgz

----

Configure the build ::

        cd Python-${PEEK_PY_VER}
        ./configure --prefix=/home/peek/cpython-${PEEK_PY_VER}/ --enable-optimizations

----

Make and Make install the software ::

        make install

----

Cleanup the download and build dir ::

        cd
        rm -rf Python-${PEEK_PY_VER}*

----

Symlink the python3 commands so they are the only ones picked up by path. ::

        cd /home/peek/cpython-${PEEK_PY_VER}/bin
        ln -s pip3 pip
        ln -s python3 python
        cd

----

Test that the setup is working ::


        RED='\033[0;31m'
        GREEN='\033[0;32m'
        NC='\033[0m' # No Color

        SHOULD_BE="/home/peek/cpython-${PEEK_PY_VER}/bin/python"
        if [ `which python` == ${SHOULD_BE} ]
        then
            echo -e "${GREEN}SUCCESS${NC} The python path is right"
        else
            echo -e "${RED}FAIL${NC} The python path is wrong, It should be ${SHOULD_BE}"
        fi

        SHOULD_BE="/home/peek/cpython-${PEEK_PY_VER}/bin/pip"
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

synerty-peek is deployed into python virtual environments.
Install the virtualenv python package ::

        pip install virtualenv


----

The Wheel package is required for building platform and plugin releases ::

        pip install wheel


Install Worker Dependencies
---------------------------

Install the parallel processing queue we use for the peek-worker tasks.

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
        sudo sed -i "s/${BEFORE}/${AFTER}/g" /etc/redis.conf

        sudo systemctl restart redis


Install Oracle Client (Optional)
--------------------------------

The oracle libraries are optional. Install them where the agent runs if you are
going to interface with an oracle database.

----

Edit :file:`~/.bashrc` and append the following to the file: ::

        # Setup the variables for ORACLE
        export LD_LIBRARY_PATH="/home/peek/oracle/instantclient_18_5:$LD_LIBRARY_PATH"
        export ORACLE_HOME="/home/peek/oracle/instantclient_18_5"

----

Source the new profile to get the new variables: ::

        source ~/.bashrc

----

Make the directory where the oracle client will live ::

        mkdir /home/peek/oracle

----

Download the following from oracle.

The version used in these instructions is **18.5.0.0.0**.

#.  Download the ZIP "Basic Package"
    :file:`instantclient-basic-linux.x64-18.5.0.0.0dbru.zip` from
    http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

#.  Download the ZIP "SDK Package"
    :file:`instantclient-sdk-linux.x64-18.5.0.0.0dbru.zip` from
    http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

Copy these files to :file:`/home/peek/oracle` on the peek server.

----

Extract the files. ::

        cd ~/oracle
        unzip instantclient-basic-linux.x64-18.5.0.0.0dbru.zip*
        unzip instantclient-sdk-linux.x64-18.5.0.0.0dbru.zip*


Install FreeTDS (Optional)
--------------------------

FreeTDS is an open source driver for the TDS protocol, this is the protocol used to
talk to a MSSQL SQLServer database.

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

.. warning:: Restart your terminal you get the new environment.

----

Install FreeTDS: ::

        sudo apt-get install freetds-dev

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
