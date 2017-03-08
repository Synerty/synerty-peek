=================================
Setting Up Plugin For Development
=================================

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
