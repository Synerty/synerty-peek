==========================
Setup OS Requirements RHEL
==========================

This section describes how to perform the setup for Red Hat Linux Server 7.4.  The Peek platform
is designed to run on Linux.

Please read through all of the documentation before commencing the installation procedure.

Installation Objective
----------------------

This Installation Guide contains specific Red Hat Linux Server 7.4 operating system requirements
for the configuring of synerty-peek.

Required Software
`````````````````

Some of the software to be installed requires internet access. For offline installation
some steps are required to be installed on another online server for the files to be
packaged and transferred to the offline server.

Below is a list of all the required software:


*   Python 3.6.x

*   Postgres 10.4.x

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

Follow the remaining section in this document to prepare your RHEL operating system for
to run the Peek Platform.

The instructions on this page don't install the peek platform, that's done later.

Install Red Hat Linux Server 7.4 OS
-----------------------------------

This section installs the Red Hat Linux Server 7.4 64bit operating system.

Create VM
`````````

Create a new virtual machine with the following specifications

*   2 CPUs
*   4gb of ram
*   50gb of disk space

Install OS
``````````

Download the RHEL ISO

`Download RHEL <https://access.redhat.com/site/downloads/content/271/>`_

----

Mount the ISO in the virtual machine and start the virtual machine.

Run through the installer manually, do not let your virtual machine software perform
a wizard or express install.

Staring Off
~~~~~~~~~~~

At the **Red Hat Enterprise Linux 7.4 installer boot menu** screen, select: ::

    Install Red Hat Enterprise Linux 7.4

----

At the language selection screen, select: ::

    English

----

Goto **DATE & TIME** screen, select the appropriate time location.

.. image:: rhel_date_and_time.png

----

Goto **KEYBOARD** screen, select the appropriate keyboard,
or leave as default.

----

Goto **NETWORK & HOST NAME** screen, enter your desired hostname or: ::

    peek

----

Goto **INSTALLATION DESTINATION** screen, for partitioning select: ::

    I will configure partitioning.

.. image:: rhel_installation_destination.png

Partition Table
~~~~~~~~~~~~~~~

We'll be creating three partitions, /boot / and swap. For a heavily used production
server you may want to create more virtual disks and separate out /var, /home, and /tmp.
With one file system per disk.

Having one file system per disk removes the need for the overhead of LVM, and the VM
software can still expand the disk and filesystem as required.

/boot
~~~~~

Select the following disk from the **ADD NEW MOUNT POINT** menu: 

Mount Point: ::

    /boot

Desired Capacity: ::

    500m

.. image:: rhel_partitioning_boot.png

swap
~~~~

Select the following disk from the **ADD NEW MOUNT POINT** menu: 

Mount Point: ::

    swap

Desired Capacity: ::

    4g

.. image:: rhel_partitioning_swap.png

/ (root)
~~~~~~~~

Select the following disk from the **ADD NEW MOUNT POINT** menu: 

Mount Point: ::

    /

Desired Capacity: ::

    100%

.. image:: rhel_partitioning_root.png

----

Select **DONE** and **BEGIN INSTALLATION**

----

While Red Hat is installing you can configure the **USER SETTINGS**, 
set **ROOT PASSWORD** and go to the **USER CREATION** screen.

Create the **peek** user.

.. image:: rhel_create_user.png

----

After the server has rebooted, deconfigure the RHEL ISO from DVD drive in the VM software.

----

The OS installtion is now complete.


What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
