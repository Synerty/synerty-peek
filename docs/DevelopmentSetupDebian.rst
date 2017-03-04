========================
Debian Development Setup
========================

Building synerty-peek
---------------------

The peek package has build scripts that generate a development build.

.. NOTE:: Dev build, it doesn't tag, commit or test upload, but still generates a build.

.. WARNING:: Omitting the dot before dev will cause the script to fail as setuptools
    adds the dot in if it's not there, which means the cp commands won't match files.

    ::

        $ ./pipbuild_platform.sh 0.0.1.dev1

Building peek-plugins
---------------------



    ::

        $ export RELEASE_DIR=/c/peek_plugins
        $ ./pipbuild.sh #.#.##
