=======================
Debian Production Setup
=======================

Building synerty-peek
---------------------

.. NOTE:: If you're building for development skip this step and continue through to
    Development Setup.

The peek package has build scripts that generate a platform build.

.. NOTE:: Prod build, it tags, commits and test uploads to testpypi.

.. WARNING:: Omitting the dot before dev will cause the script to fail as setuptools
    adds the dot in if it's not there, which means the cp commands won't match files.

    ::

        $ ./pipbuild_platform.sh #.#.##
        $ ./pypi_upload.sh
