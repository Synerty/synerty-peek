.. _package_peek_plugins:

====================
Package Peek Plugins
====================

Packaging a Production Release
------------------------------

A release is a zip file containing all the required python packages to install
the plugins after the platform release has installed.

.. important:: Windows users must use bash. :ref:`setup_msys_git`

----

Create the release directory:

::

        mkdir ~/plugin-release-dir


.. note:: You should clean up any previously packaged releases:
    :code:`rm -rf ~/plugin-release-dir`

----

Change to release directory:

::

        cd ~/plugin-release-dir


----

Copy your private plugins "source distributions" into the release directory.

OPTION 1)

To build a source distribution, cd to the plugin dir and run the following: ::

        # build the source distribution
        cd ~/project/peek-plugin-example
        python setup.py sdist

        # Copy the source distribution to our release dir
        cp ~/project/peek-plugin-example/dist/peek-plugin-example-#.#.#.tar.gz ~/plugin-release-dir

OPTION 2)

The documentation to create plugins includes a :file:`publish.sh` script, this does the
following:

*   Checks for uncomitted changes
*   Updates version numbers on variose files in the code
*   Commits the version updates
*   Tags the commit
*   Optionally, uploads the plugin to PYPI
*   Optionally, copies the dist to :command:`$RELEASE_DIR`

::

        export RELEASE_DIR=`ls -d ~/plugin-release-dir`

        # build the source distribution
        cd ~/project/peek-plugin-example
        bash publish.sh #.#.#

        # Where #.#.# is the new version


.. note:: Repeat this step for each private plugin.

----

Make a wheel dir for windows or Linux.

Windows: ::

        mkdir ~/plugin-release-dir/plugin-win
        cd    ~/plugin-release-dir/plugin-win

Linux: ::

        mkdir ~/plugin-release-dir/plugin-linux
        cd    ~/plugin-release-dir/plugin-linux

----

Build Wheel archives for your private requirements and dependencies.
Wheel archives are "binary distributions", they are compiled into the python byte code
for specific architectures and versions of python.

This will also pull in all of the dependencies, and allow for an offline install later.

::

        # Example of pulling in the desired public plugins as well
        PUB="peek-plugin-noop"
        PUB="$PUB peek-core-user"
        PUB="$PUB peek-plugin-active-task"
        PUB="$PUB peek-plugin-chat"

        # Private Plugins
        PRI=`ls ../*.tar.gz

        # Build the wheels
        pip wheel --no-cache --find-links ../ $PRI $PUB


----

Zip the plugin dist dir.

Windows: ::

        cd ~
        tar cvjf plugin-win.tar.bz2 -C ~/plugin-release-dir plugin-win

Linux: ::

        cd ~
        tar cvjf plugin-linux.tar.bz2 -C ~/plugin-release-dir plugin-linux


----

Cleanup the release directory: ::

        rm -rf cd ~/plugin-release-dir


What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
