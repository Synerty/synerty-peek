=====================
Publish Peek Platform
=====================

Building synerty-peek
---------------------

Development
```````````

The peek package has build scripts that generate a development build.
::

        ./pipbuild_platform.sh 0.0.1.dev1

.. NOTE:: Dev build, it doesn't tag, commit or test upload, but still generates a build.

.. WARNING:: Omitting the dot before dev will cause the script to fail as setuptools
    adds the dot in if it's not there, which means the cp commands won't match files.

Production
``````````

The peek package has build scripts that generate a platform build.
::

        ./pipbuild_platform.sh #.#.##
        ./pypi_upload.sh

.. NOTE:: Prod build, it tags, commits and test uploads to testpypi.  If you're building
    for development, skip this step and go back to Development.

.. WARNING:: Omitting the dot before dev will cause the script to fail as setuptools
    adds the dot in if it's not there, which means the cp commands won't match files.
