=================
Offline Packaging
=================

Windows Make
------------

Install wget

https://sourceforge.net/projects/gnuwin32/files/wget/1.11.4-1/wget-1.11.4-1-setup.exe/download

----

Open gitbash, run the following

::

    DIR=`pwd`

    [ -d peek_dist ] && rm -rf peek_dist
    mkdir peek_dist/py
    mkdir peek_dist/client-build-ns/tmp
    mkdir peek_dist/client-build-web/tmp
    mkdir peek_dist/server-build-web/tmp


    cd $DIR/peek_dist/py
    pip wheel --no-cache synerty-peek
    wget 'http://www.lfd.uci.edu/~gohlke/pythonlibs/tuth5y6k/Shapely-1.5.17-cp35-cp35m-win_amd64.whl'

    cd $DIR/peek_dist/client-build-ns/tmp
    wget 'https://raw.githubusercontent.com/Synerty/peek-client-fe/master/peek_client_fe/build-ns/package.json'
    npm install
    cd ..
    mv tmp/node_modules .
    rm -rf tmp

    cd $DIR/peek_dist/client-build-web/tmp
    wget 'https://raw.githubusercontent.com/Synerty/peek-client-fe/master/peek_client_fe/build-web/package.json'
    npm install
    cd ..
    mv tmp/node_modules .
    rm -rf tmp

    cd $DIR/peek_dist/server-build-web/tmp
    wget 'https://raw.githubusercontent.com/Synerty/peek-server-fe/master/peek_server_fe/build-web/package.json'
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

