=============================
Setup OS Requirements Windows
=============================

The Peek platform is designed to run on Linux, however, it is compatible with windows.
Please read through all of the documentation before commencing the installation
procedure.

|

Installation Objective
----------------------

This *Installation Guide* contains specific Windows operating system requirements for the
configuring of synerty-peek.

|

Required Software
`````````````````

Some of the software to be installed requires internet access.  For offline installation
some steps are required to be installed on another online server for the files to be
packaged and transferred to the offline server.

Below is a list of all the required software:

*  Microsoft .NET Framework 3.5 Service Pack 1
*  Visual C++ Build Tools 2015
*  PostgresSQL 9.6.2+ or Microsoft® SQL Server® 2014 Express
*  Node.js 7+ and NPM 3+
*  Python 3.5
*  FreeTDS

|

Optional  Software
``````````````````

*  7zip
*  Notepad ++
*  Installing Oracle Libraries (Instructions in the procedure)

Installation of 7zip is optional. This tool will come in handy during the process but
is not required.

----

Installation of Notepad ++ is optional.  Notepad ++ is a handy tool for viewing
documents and has useful features.

----

Installing Oracle Libraries is required if you intend on installing the peek agent.
Instruction for installing the Oracle Libraries are in the *Online Installation Guide*.

|

OS Commands
-----------

The config file for each service in the peek platform describes the location of the BASH
interpreter. Peek is coded to use the bash interpreter and basic posix compliant utilities
for all OS commands.

When peek generates it's config it should automatically choose the right interpreter. ::

        "C:\Program Files\Git\bin\bash.exe" if isWindows else "/bin/bash"

|

Online Installation Guide
-------------------------

Create Account
``````````````

Create a windows user account for peek with admin rights.

----

:Account Type: Administrator
:Username: peek
:Password: PA$$W0RD

----

sign in to the peek account

|

Microsoft .NET Framework 3.5 Service Pack 1
```````````````````````````````````````````

**Online Installation:**

:Download: `<http://download.microsoft.com/download/2/0/e/20e90413-712f-438c-988e-fdaa79a8ac3d/dotnetfx35.exe>`_
:From: `<https://www.microsoft.com/en-ca/download>`_

**Offline Installation:**

:Download: `<https://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe>`_

.. note:: Restart if prompted to restart.

|

Visual C++ Build Tools 2015
```````````````````````````

**Online Installation:**

:Download: `<http://go.microsoft.com/fwlink/?LinkId=691126>`_
:From: `<http://landinghub.visualstudio.com/visual-cpp-build-tools>`_

**Offline Installation:**

Install using the ISO

:Download: `<https://www.microsoft.com/en-US/download/details.aspx?id=48146>`_

|

.. _postgressql:

PostgresSQL
```````````

.. NOTE:: This install procedure contains instructions for both PostgresSQL and MSSQL.
    To install Microsoft® SQL Server® 2014 Express, see:
    :ref:`microsoft_sql_server_2014_express`

:Download: `<https://www.enterprisedb.com/downloads/postgres-postgresql-downloads#windows>`_
:From: `<https://www.postgresql.org>`_

----

Install PostgresSQL with default settings

----

Run pgAdmin4

----

Open the Query Tool

.. image:: pgAdmin4-queryTool.jpg

----

Create the peek user, run the following script: ::

    CREATE USER peek WITH
        LOGIN
        SUPERUSER
        CREATEDB
        CREATEROLE
        INHERIT
        REPLICATION
        CONNECTION LIMIT -1
        PASSWORD 'bford';

.. image:: pgAdmin4-userQuery.jpg

----

Create the peek database, run the following script: ::

    CREATE DATABASE peek WITH
        OWNER = peek
        ENCODING = 'UTF8'
        CONNECTION LIMIT = -1;

----

Confirm database was created

.. image:: pgAdmin4-refresh.jpg

|

.. image:: pgAdmin4-peekDatabase.jpg

|

.. _microsoft_sql_server_2014_express:

Microsoft® SQL Server® 2014 Express
```````````````````````````````````

.. NOTE:: This install procedure contains instructions for both PostgresSQL and MSSQL.
    To install PostgresSQL, see: :ref:`postgressql`

:From: `<https://www.microsoft.com/en-ca/download/details.aspx?id=42299>`_

----

Choose directory for extracted files: ::

        C:\SQLEXPRWT_x64_ENU\

----

Select "New SQL Server stand-alone installation"

----

Feature Selection: check all Features

.. image:: SQLServer-FeatureSelection.jpg

----

Instance Configuration: change the named instance to 'peek'. This will update the
'Instance ID'

----

Server Configuration: Select browse from the 'Account Name' drop-list and check names
for 'peek'.  Select ok then enter the account password

.. image:: SQLServer-ServerConfiguration.jpg

----

Database Engine Configuration: Select "Mixed Mode" and enter a password

.. image:: SQLServer-DBEngConfig.jpg

|

Create Peek Database
~~~~~~~~~~~~~~~~~~~~

Start Microsoft SQL Server Management Studio

----

Connect to PEEK database engine

----

Create new database 'peek'

|

SQL Server Configuration Manager
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Open the SQL Server Configuration Manager (SQLServerManager12.msc) from the start menu

----

Expand, SQL Server Network Configuration

----

Select, Protocols for PEEK

----

Go to, TCP/IP Properties and select the IP Addresses tab

----

Go to, section with the IP Address set to 127.0.0.1

----

Set Enabled "Yes"

----

Set TCP Port to "1433"

.. image:: set_tcp_port.jpg

----

Enable the TCP/IP Protocol

.. image:: enable_tcpip.png

----

Select 'OK'

----

Restart the server service.

.. image:: SQLServer-RestartServices.jpg

|

FreeTDS
~~~~~~~

:Download: `<https://github.com/ramiro/freetds/releases/download/v0.95.95/freetds-v0.95.95-win-x86_64-vs2015.zip>`_
:From: `<https://github.com/ramiro/freetds/releases>`_

----

Unzip contents into ::

        C:\Users\peek\freetds-v0.95.95

----

Add PATH to environment variables ::

        C:\Users\peek\freetds-v0.95.95\bin

----

Create 'freetds.conf' in "C:\" ::

        [global]
            port = 1433
            instance = peek
            tds version = 7.0
            dump file = /tmp/freetds.log

|

dll files
~~~~~~~~~

:Download: `<http://indy.fulgan.com/SSL/openssl-1.0.2j-x64_86-win64.zip>`_
:From: `<http://indy.fulgan.com/SSL/>`_

----

Ensure these files are in the system32 folder:

*  libeay32.dll

*  ssleay32.dll

----

You will need to duplicate the above files and name them as per below:

*  libeay32MD.dll

*  ssleay32MD.dll

|

Python 3.5
``````````

:Download: `<https://www.python.org/ftp/python/3.5.3/python-3.5.3rc1-amd64.exe>`_
:From: `<https://www.python.org/downloads/windows/>`_

----

Check the 'Add Python 3.5 to PATH' and select 'Customize Installation'

.. image:: Python-Install.jpg

----

Update the 'Customize install location' to PATH C:\Users\peek\Python35\

.. image:: Python-AdvancedOptions.jpg

----

Confirm PATH(s) to environment variables ::

        echo %PATH%

        ...

        C:\Users\peek\Python35\
        C:\Users\peek\Python35\Scripts\

|

SymLinks
````````

Enabling SymLinks.

`<https://github.com/git-for-windows/git/wiki/Symbolic-Links>`_

----

Launch: "gpedit.msc" and Navigate to
    Computer configuration
        Windows Settings
        Security Settings
        Local Policies
        User Rights Assignment

.. image:: gpedit-CreateSymlinks.jpg

----

Double click on "Create symbolic links"

----

Click "Add User or Group", add "peek", then "OK" out of the dialogues.

.. image:: gpedit-AddUser.jpg

----

You will need to logout and log back in for the change to take effect

.. Note:: This setting has no effect on user accounts that belong to the Administrators
    group.  Those users will always have to run mklink in an elevated environment as
    Administrator.

|

Enable Development
``````````````````

This applies to windows 10, and may apply to other windows versions as well.

`<https://msdn.microsoft.com/en-us/windows/uwp/get-started/enable-your-device-for-development>`_

Enable your device for development

----

Click the "Start" menu and select "Settings"

----

Select 'Update & Security'

.. image:: DevMode-UpdateSecurity.jpg

----

Click on the "For developers" tab on the left.

----

Select 'Developer Mode', and acknowledge the warning.

.. image:: DevMode-ForDevelopers.jpg

|

Installing Oracle Libraries
---------------------------

The oracle libraries are optional. Install them where the agent runs if you are going
to interface with an oracle database.

|

Oracle Instant Client
`````````````````````

:Download: `<http://download.oracle.com/otn/nt/oracle12c/121020/winx64_12102_client.zip>`_
:From: `<http://www.oracle.com/technetwork/database/enterprise-edition/downloads/database12c-win64-download-2297732.html>`_

----

Unzip contents into a temporary location

Run the installer (setup.exe)

Select the following options

:Install Type: Runtime
:Oracle Base: C:\\Users\\peek\\oracle
:Oracle Home: C:\\Users\\peek\\oracle\\client12c

----

Reboot windows, or logout and login to ensure the PATH updates.

|

Installing synerty-peek
-----------------------

From here you will be deploying either the *Production Platform Setup*
(ProductionSetup.rst) or the *Development Setup*
(DevelopmentSetup.rst).


