=======================
Troubleshooting Windows
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

