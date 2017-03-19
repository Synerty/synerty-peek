#!/usr/bin/env bash
exit


# Add wget to the path if required
DIR=`pwd`

[ -d peek_dist ] && rm -rf peek_dist
mkdir -p peek_dist/py
mkdir -p peek_dist/client-build-ns/tmp
mkdir -p peek_dist/client-build-web/tmp
mkdir -p peek_dist/server-build-web/tmp


cd $DIR/peek_dist/py
pip install wheel
pip wheel --no-cache synerty-peek

----

Leave the gitbash terminal open

----

:Download: `<http://www.lfd.uci.edu/~gohlke/pythonlibs/#shapely>`_
:From: `<https://pypi.python.org/pypi/Shapely>`_

Download Shapely >= 1.5.17 and save in the "$DIR/peek_dist/py" directory

----

:Download: `<https://raw.githubusercontent.com/Synerty/peek-client-fe/master/peek_client_fe/build-ns/package.json>`_

Download the package.json and save in the "$DIR/peek_dist/client-build-ns/tmp" directory

----

Run the following

::

    cd $DIR/peek_dist/client-build-ns/tmp
    npm install
    cd ..
    mv tmp/node_modules .
    rm -rf tmp

----

:Download: `<https://raw.githubusercontent.com/Synerty/peek-client-fe/master/peek_client_fe/build-web/package.json>`_

Download the package.json and save in the "$DIR/peek_dist/client-build-web/tmp" directory

----

Run the following

::

    cd $DIR/peek_dist/client-build-web/tmp
    npm install
    cd ..
    mv tmp/node_modules .
    rm -rf tmp

----

:Download: `<https://raw.githubusercontent.com/Synerty/peek-server-fe/master/peek_server_fe/build-web/package.json>`_

Download the package.json and save in the "$DIR/peek_dist/server-build-web/tmp" directory

----

Run the following

::

    cd $DIR/peek_dist/server-build-web/tmp
    npm install
    cd ..
    mv tmp/node_modules .
    rm -rf tmp

    cd $DIR

----

Archive the peek_dist dir and move it to the offline server

Windows Install
---------------

On the destination server, run the following in git bash

::

    DIST_DIR="/c/users/peek/peek_dist"
    SP="/c/Users/peek/peek_x.x.x/Lib/site-packages"

    cd /c/users/peek
    virtualenv peek_x.x.x
    /c/users/peek/peek_x.x.x/activate

    pip install --no-index --no-cache --find-links $DIST_DIR/py synerty-peek Shapely


    mv $DIST_DIR/peek_dist/client-build-ns/node_modules $SP/peek_client_fe/build-ns
    mv $DIST_DIR/peek_dist/client-build-web/node_modules $SP/peek_client_fe/build-web
    mv $DIST_DIR/peek_dist/server-build-web/node_modules $SP/peek_server_fe/build-web

