====================
Develop Peek Plugins
====================

** TODO **

** TODO **

** TODO **

** TODO **

This document has not been started, or finished.

** TODO **

** TODO **

** TODO **

** TODO **

Developing
----------

Herein, "tns" refers to the nativescript command line utility.
"tsc" is the typescript compiler command line utility.

Some parts of the peek-plugins for the peek-client are installed under
node_modules/@peek-client/peek_plugin_name.

tns doesn't compile typescript (.ts) files that are installed under node_modules.

To solve this, Peek places a tsconfig file at node_modules/@peek-client/tsconfig.json.
tsc must be run in this directory prior to a tns build.

::

    cd peek-client-fe/peek_client_fe/node_modules/@peek-client
    tsc --watch --pretty


The next issue is that nativescript doesn't incrementally update node_modules when
changes are made. (TODO, Test and finish this section)

::

    rsync -avP --delete * ../../platforms/android/src/main/re^C

Rebuilding
``````````

#.  Delete the "android" directory under the "platforms" directory

::

    # Get the emulator name
    android list avd | grep Name

    # Wipe the data and start emulator
    # emulator -avd <Name> -wipe-data
    emulator -avd Peek_Test -wipe-data

    # RM platform
    rm -rf playform/android




Deploying
---------

Android
```````

Setting Up Plugin For Development
---------------------------------

#.  Clone the plugin
#.  Install the plugin in development mode, so peek can load it. Run ::

    python setup.py develop

#.  Enable the plugin to the appropriate peek-<service>.home/config.json file.

Finished. You should now be able to run peek and the plugin will load.

Building peek-plugins
---------------------

The peek package plugins contain build scripts that generate a platform build.
::

        export RELEASE_DIR=/c/peek_plugins
        ./pipbuild.sh #.#.##

.. WARNING:: Omitting the dot before dev will cause the script to fail as setuptools
    adds the dot in if it's not there, which means the cp commands won't match files.
