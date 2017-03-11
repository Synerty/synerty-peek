======================================
Peek Client - NativeScript Development
======================================

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



Deploying
---------

Android
```````

