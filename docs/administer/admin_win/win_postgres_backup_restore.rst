.. _win_postgres_backup_restore:


Backup and Restore PostGreSQL DB
````````````````````````````````

Backup
~~~~~~

TODO

Restore
~~~~~~~
This document describes how to restore the PostGreSQL database for Peek on a windows
server.

.. warning:: This procedure deletes the existing Peek database.
            Ensure you have everything in order, backed up and correct before executing
            each command. (Including the server your connected to)

----

Stop all Peek services from the windows services.

These can be quickly accessed by pressing CTRL+ESC to bring up the task manager and then
selecting the services tab.

----

Look in the windows tray / notifications area to see if the **PGAdmin4** server is
running.

If it is, right click on it and select **Shutdown Server**

----

Open a Powershell window, and change directory to the location of the backup.
For example:

::

    cd 'C:\Users\Peek\Downloads\v1.1.6.3\'

----

Run the command to drop the existing Peek database.
You won't see any errors or feedback when this succeeds.

::

    dropdb -h 127.0.0.1 -U peek peek


----

Run the command to create a fresh new Peek database.
You won't see any errors or feedback when this succeeds.

::

    createdb -h 127.0.0.1 -U peek -O peek peek

----

Now restore the PostGreSQL database. This will create the schema and load the data.

::

    psql.exe -h 127.0.0.1 -U peek -d peek -f .\peek_db.sql

