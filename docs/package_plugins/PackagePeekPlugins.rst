====================
Package Peek Plugins
====================

**TODO** This is really just for Synerty internal plugins at this stage.

A release is a zip file containing all the required python packages to install
the plugins after the platform release has installed.

----

Open bash, and run the following

::

    # CD to the synerty-peek project
    cd synerty-peek

    # Ensure RELEASE_DIR is where you want it
    echo $RELEASE_DIR
    ./publish_plugins.sh V.E.R

    # Now build the wheels
    # NOTE: This WILL pull down some platform dependencies, it will also compile cx_Oracle
    cd $RELEASE_DIR
    pip wheel *

    # Now clean out the src packages
    rm *.tar.gz


What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
