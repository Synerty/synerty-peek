=============================
Setup OS Requirements Windows
=============================

The Peek platform is designed to run on Linux, however, it is compatible with windows.
Please read through all of the documentation before commencing the installation
procedure.

Installation Objective
----------------------

This *Installation Guide* contains specific Windows operating system requirements for the
configuring of synerty-peek.

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
*  Virtualenv
*  FreeTDS

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

OS Commands
-----------

The config file for each service in the peek platform describes the location of the BASH
interpreter. Peek is coded to use the bash interpreter and basic posix compliant utilities
for all OS commands.

When peek generates it's config it should automatically choose the right interpreter. ::

        "C:\Program Files\Git\bin\bash.exe" if isWindows else "/bin/bash"

Installation Guide
------------------

The following sections begin the installation procedure.

Create Peek OS User
-------------------

Create a windows user account for peek with admin rights.

.. tip:: Search for **Computer Management** from the start menu, and use that.

----

:Account Type: Administrator
:Username: peek
:Password: PA$$W0RD

----

Sign in to the peek account.

.. important:: All steps after this point assume you're logged in as the peek user.

.. tip:: Run the ":command:`control userpasswords2`" command from the run window
            to have peek automatically login.
            This is useful for development virtual machines.

MS .NET Framework 3.5 SP1
-------------------------

**Online Installation:**

:Download: `<http://download.microsoft.com/download/2/0/e/20e90413-712f-438c-988e-fdaa79a8ac3d/dotnetfx35.exe>`_
:From: `<https://www.microsoft.com/en-ca/download>`_

**Offline Installation:**

:Download: `<https://download.microsoft.com/download/2/0/E/20E90413-712F-438C-988E-FDAA79A8AC3D/dotnetfx35.exe>`_

.. note:: Restart if prompted to restart.

Visual C++ Build Tools 2015
---------------------------

**Online Installation:**

:Download: `<http://go.microsoft.com/fwlink/?LinkId=691126>`_
:From: `<http://landinghub.visualstudio.com/visual-cpp-build-tools>`_

**Offline Installation:**

Install using the ISO

:Download: `<https://www.microsoft.com/en-US/download/details.aspx?id=48146>`_

Install Python 3.6
------------------

:Download: `<https://www.python.org/ftp/python/3.6.1/python-3.6.1-amd64.exe>`_
:From: `<https://www.python.org/downloads/windows/>`_

----

Check the 'Add Python 3.6 to PATH' and select 'Customize Installation'

.. image:: Python-Install.jpg

----

Update the 'Customize install location' to PATH C:\Users\peek\Python35\

.. image:: Python-AdvancedOptions.jpg

----

Confirm PATH(s) to environment variables ::

        echo %PATH%

        ...

        C:\Users\peek\Python36\
        C:\Users\peek\Python36\Scripts\


Virtual Environment
```````````````````

synerty-peek is deployed into python virtual environments.
Install the virtualenv python package

----

Open the command prompt and run the following command:

::

        pip install virtualenv


----

The Wheel package is required for building platform and plugin releases ::

        pip install wheel


.. _requirements_windows_postgressql:

PostgresSQL (Optional)
----------------------

This install procedure contains instructions for both PostgresSQL and MSSQL.

Synerty recommends PostGreSQL for Production, Development, Windows and Linux servers.

To install Microsoft® SQL Server® 2014 Express, goto section :
:ref:`microsoft_sql_server_2014_express`

:Download: `<https://www.enterprisedb.com/downloads/postgres-postgresql-downloads#windows>`_
:From: `<https://www.postgresql.org>`_

----

Install PostgresSQL with default settings.

Make a note of the postgres user password that you supply, you'll need this.

.. warning:: Generate a strong password for both peek and postgres users for
    production use.

    Synerty recommends 32 to 40 chars of  capitals, lower case and numbers, with some
    punctuation, best to avoid these ` / \\ ' "

    `<https://strongpasswordgenerator.com>`_

----

Run pgAdmin4

----

Open the Query Tool

.. image:: pgAdmin4-queryTool.jpg

----

Create the peek user, run the following script: ::

    CREATE USER peek WITH
        LOGIN
        CREATEDB
        INHERIT
        REPLICATION
        CONNECTION LIMIT -1
        PASSWORD 'PASSWORD';

.. note:: Replace :code:`PASSWORD` with a password of your choice or requirements

Example:

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

.. image:: pgAdmin4-peekDatabase.jpg

.. _microsoft_sql_server_2014_express:

MS SQL Server 2014 Express (Optional)
-------------------------------------

This install procedure contains instructions for both PostgresSQL and MSSQL.
To install PostgresSQL, see: :ref:`requirements_windows_postgressql`

The MS SQL Server Express server is suitable for a development environment, for
production servers, Synerty recommends using PostGreSQL or
MS SQL Server 2014 R2 Standard.

:From: `<https://www.microsoft.com/en-ca/download/details.aspx?id=42299>`_

----

Choose directory for extracted files: ::

        C:\SQLEXPRWT_x64_ENU\

----

Select "New SQL Server stand-alone installation"

----

On the **Feature Selection**

#.  check all Features

.. image:: SQLServer-FeatureSelection.jpg

----

On the **Instance Configuration** screen

#.  change the named instance to 'peek'. This will update the
'Instance ID'

----

On the **Server Configuration** screen, Click Next.

----

On the **Database Engine Configuration** screen.

#.  Select "Mixed Mode"
#.  Enter and re-enter the SA password

.. image:: SQLServer-DBEngConfig.jpg

----

Click through the remainder of the installtion steps.

Create Peek Database
````````````````````

Start Microsoft SQL Server Management Studio

----

Connect to PEEK database engine

----

Create new database 'peek'.

#.  Right click on "Databases"
#.  Select "New Databases"
#.  Enter "peek" in the "Database name" field
#.  Click OK

----

The peek database is now created


Create Peek User
````````````````

This section creates the peek SQL user.

----

Still in the **SQL Server Management Studio**,

#.  Click **New Query**
#.  Paste the following SQL in, and alter the password.
#.  Click **Execute**


::

        USE [master]
        GO
        CREATE LOGIN [peek] WITH PASSWORD=N'PASSWORD', DEFAULT_DATABASE=[peek],
            CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
        GO
        USE [peek]
        GO
        CREATE USER [peek] FOR LOGIN [peek]
        GO
        USE [peek]
        GO
        ALTER ROLE [db_owner] ADD MEMBER [peek]
        GO


Enable Local TCP Connections
````````````````````````````

Open the SQL Server Configuration Manager (SQLServerManager12.msc) from the start menu

----

Expand, SQL Server Network Configuration

----

Select, Protocols for PEEK

----

Double click the row with Protocol Name = "TCP/IP"

----

Enable the TCP/IP Protocol

#.  On the Protocol tab

#.  Set "Enabled" = "Yes"

#.  Set "Listen All" = "No"

.. image:: enable_tcpip.png

----

Enable the IP

#.  Select the IP Addresses tab

    Go to the section where "IP Address" = "127.0.0.1"

#. Set Enabled "Yes"

#.  Set TCP Port to "1433"

    Click OK

.. image:: set_tcp_port.jpg


----

Select 'OK'

----

Restart the server service.

.. image:: SQLServer-RestartServices.jpg

Install FreeTDS
---------------

FreeTDS is an open source driver for the TDS protocol, this is the protocol used to
talk to the MSSQL SQLServer database.

Peek needs this installed as it uses the pymssql python database driver, which depends on
FreeTDS.

----

:Download: `<https://github.com/ramiro/freetds/releases/download/v0.95.95/freetds-v0.95.95-win-x86_64-vs2015.zip>`_
:From: `<https://github.com/ramiro/freetds/releases>`_

----

Unzip contents into ::

        C:\Users\peek

----

Rename :file:`C:\\users\\peek\\freetds-v0.95.95` to :file:`C:\\users\\peek\\freetds`

----

Under Control Panel -> System -> Advanced system settings

Add the following to PATH in the "System" environment variables ::

        C:\Users\peek\freetds\bin

.. tip:: On Win 10, enter "environment" in the task bar search and select
            **Edit the system environment variables**

----

Create file :file:`freetds.conf` in :file:`C:\\` ::

        [global]
            port = 1433
            instance = peek
            tds version = 7.4
            dump file = c:\users\peek\freetds.log


dll files
`````````

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

Install Oracle Client (Optional)
--------------------------------

The oracle libraries are optional. Install them where the agent runs if you are going to
interface with an oracle database.

----

Download the following from oracle.

The version used in these instructions is **12.2.0.1.0**.

#.  Download the "Instant Client Package - Basic" from
    http://www.oracle.com/technetwork/topics/winx64soft-089540.html

#.  Download the "Instant Client Package - SDK" from
    http://www.oracle.com/technetwork/topics/winx64soft-089540.html

----

Extract both the zip files to :file:`C:\\Users\\peek\\oracle`

----

Under Control Panel -> System -> Advanced system settings

Add the following to PATH in the "System" environment variables ::

        C:\Users\peek\oracle\instantclient_12_2

.. tip:: On Win 10, enter "environment" in the task bar search and select
            **Edit the system environment variables**


----

The Oracle instant client needs :file:`msvcr120.dll` to run, download and install the
x64 version from the following microsoft site.

`<https://www.microsoft.com/en-ca/download/details.aspx?id=40784>`_

----

Reboot windows, or logout and login to ensure the PATH updates.

Enable SymLinks
---------------

Enabling SymLinks for development.
Peek no longer uses Symlinks, so this step can be skipped.

Thanks to : `<https://github.com/git-for-windows/git/wiki/Symbolic-Links>`_
for the instructions.

----

Launch: "gpedit.msc" and Navigate to

#.  Computer configuration

#.  Windows Settings

#.  Security Settings

#.  Local Policies

#.  User Rights Assignment

#.  Double click on "Create symbolic links"

.. image:: gpedit-CreateSymlinks.jpg

----

Click "Add User or Group", add "peek", then "OK" out of the dialogues.

.. image:: gpedit-AddUser.jpg

----

You will need to logout and log back in for the change to take effect

.. Note:: This setting has no effect on user accounts that belong to the Administrators
    group.  Those users will always have to run mklink in an elevated environment as
    Administrator.

Enable Development
------------------

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



What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.


