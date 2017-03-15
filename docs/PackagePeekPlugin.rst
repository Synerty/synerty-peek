===================
Package Peek Plugin
===================

.. note:: The Windows or Debian requirements must be followed before following this guide.

**TODO** This is really just for Synerty internal plugins at this stage.


A release is a zip file containing all the required python packages to install
the plugins after the platform release has installed.

Building a Windows Plugin Release
---------------------------------

Open git bash, and run the following

::

    # CD to the synerty-peek project
    cd synerty-peek

    # Ensure RELEASE_DIR is where you want it
    echo $RELEASE_DIR
    ./pipbuild_plugins.sh V.E.R

    # Now build the wheels
    # NOTE: This WILL pull down some platform dependencies, it will also compile cx_Oracle
    cd $RELEASE_DIR
    pip wheel *

    # Now clean out the src packages
    rm *.tar.gz



Building a Linux Plugin Release
-------------------------------

Open a bash prompt and run the following

::

    # CD to the synerty-peek project
    cd synerty-peek

    # Ensure RELEASE_DIR is where you want it
    echo $RELEASE_DIR
    ./pipbuild_plugins.sh V.E.R

    # Now build the wheels
    # NOTE: This WILL pull down some platform dependencies, it will also compile cx_Oracle
    cd $RELEASE_DIR
    pip wheel *

    # Now clean out the src packages
    rm *.tar.gz

