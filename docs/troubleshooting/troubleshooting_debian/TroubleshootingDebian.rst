======================
Troubleshooting Debian
======================

Test cx_Oracle in Python
````````````````````````

Use the following instructions to test the installaion of cx_Oracle

----

Login as peek and run:

::

    python

----

Run the following commands in Python:

::

    import cx_Oracle
    con = cx_Oracle.connect('username/password@hostname/instance')
    print con.version
    # Expcect to see "12.1.0.2.0"
    con.close()


OSError: inotify instance limit reached
```````````````````````````````````````

This is caused when developing peek. The Peek Platform watches the files in each plugin
and then copies them the the UI build directories as they change, EG build-web.

There are quite a few files to monitor and the limits are nice and conservative on Linux
by default

----

To solve this problem, run the following command as root

::

        echo "fs.inotify.max_user_instances=2048" >> /etc/sysctl.conf
        echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf
        sysctl -p


