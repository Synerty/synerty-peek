=============================
Setup OS Requirements Windows
=============================



Installation Objective
----------------------




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

