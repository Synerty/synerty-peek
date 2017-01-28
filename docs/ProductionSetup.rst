===================
Production Platform
===================

.. WARNING:: This document extends, Synerty Peek Installation (Installation.rst).

Windows
-------

Run the command prompt as administrator then enter the bash shell.

#.  synerty-peek::

        $ pip install synerty-peek

#.  Install front end packages ::

        $ cd `dirname $(which python)`/lib/site-packages/peek_client_fe
        $ npm install
        $ cd `dirname $(which python)`/lib/site-packages/peek_server_fe
        $ npm install

#.  Symlink the tsconfig.json and node_modules file and directory in the parent
directory of peek-client-fe, peek-server-fe and the plugins. These steps are run in the
directory where the projects are checked out from. These are required for the frontend
typescript compiler. ::

        > mklink /J node_modules peek-client-fe\peek_client_fe\node_modules
        > mklink /J tsconfig.json peek-client-fe\peek_client_fe\tsconfig.json

    #.  ::

            $ cd peek-server-fe/peek_server_fe/
            $ ng build

            $ cd peek-client-fe/peek_client_fe/
            $ ng build

#.  Install front end packages::

        $ cd `dirname $(which python)`/lib/site-packages/peek_client_fe
        $ npm install




Running synerty-peek
````````````````````



Debian Linux
------------
