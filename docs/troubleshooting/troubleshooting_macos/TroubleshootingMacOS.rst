=======================
Troubleshooting macOS
=======================

Test cx_Oracle in Python
````````````````````````

Use the following instructions to test the installaion of cx_Oracle

----

Open the "Python 3.5 (64-bit)" application from the windows start menu.

----

Run the following commands in Python: ::

        import cx_Oracle
        con = cx_Oracle.connect('username/password@hostname/instance')
        print con.version
        # Expcect to see "12.1.0.2.0"
        con.close()



ORA-21561: OID generation failed
````````````````````````````````

In macOS, You might see the following error : ::

        sqlalchemy.exc.DatabaseError: (cx_Oracle.DatabaseError) ORA-21561: OID generation failed

This is caused by the macOS hostname under "sharing" not matching the name in /etc/hosts

----

Run hostname to get the name of the mac : ::

        Synerty-256:build-web jchesney$ hostname
        syn256.local

----

Confirm that it matches the hostnames for 127.0.0.1 and ::1 in /etc/hosts : ::

        Synerty-256:build-web jchesney$ cat /etc/hosts
        ##
        # Host Database
        #
        # localhost is used to configure the loopback interface
        # when the system is booting.  Do not change this entry.
        ##
        127.0.0.1	localhost syn256.local
        255.255.255.255	broadcasthost
        ::1             localhost syn256.local


