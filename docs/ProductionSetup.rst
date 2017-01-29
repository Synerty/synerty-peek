===================
Production Platform
===================

.. WARNING:: This document extends, Synerty Peek Installation (Installation.rst).

Windows
-------

Run the command prompt **as administrator** then enter the bash shell.

#.  synerty-peek::

        $ pip install synerty-peek

#.  peek-plugins

    From saved directory::

            $ pip install

#.  Install front end packages ::

        $ cd `dirname $(which python)`/lib/site-packages/peek_client_fe
        $ npm install
        $ cd `dirname $(which python)`/lib/site-packages/peek_server_fe
        $ npm install

#.  Symlink the tsconfig.json and node_modules file and directory in the parent
directory of peek-client-fe. These steps are run in the
directory where the projects are checked out from. These are required for the frontend
typescript compiler. ::

        $ exit
        > cd C:\Users\peek\Python35\Lib\site-packages
        > mklink /J node_modules peek-client-fe\peek_client_fe\node_modules
        > bash
        $ ln -s ~/Python35/Lib/site-packages/peek_client_fe/tsconfig.json .

    #.  ::

            $ python ~/Python35/Lib/site-packages/peek_server/run_peek_server.py
            $ cd ~/Python35/Lib/site-packages/peek_server_fe/
            $ ng build

            $ python ~/Python35/Lib/site-packages/peek_client/run_peek_client.py
            $ cd ~/Python35/Lib/site-packages/peek_client_fe/
            $ ng build

Running synerty-peek
````````````````````



Debian Linux
------------
