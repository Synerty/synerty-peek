=====================
Publish Peek Platform
=====================

Building a Production Release
-----------------------------

The peek package has build scripts that generate a platform build

----

Open the command prompt and enter the bash shell

----

Change root directory of synerty-peek, example:

::

        cd ~peek/peek-dev/synerty-peek/


----

Check and take note of synerty-peek's latest release version on
`pypi <https://pypi.python.org/pypi/synerty-peek/>`_

----

Run the follow command being sure to increment the version number:

::

        ./publish_platform.sh #.#.##


.. note:: Prod build, it tags, commits and test uploads to
    `testpypi <https://testpypi.python.org/pypi/synerty-peek>`_.

----

Run the following script to upload the new release to
`pypi <https://pypi.python.org/pypi/synerty-peek/>`_:

::

        ./pypi_upload.sh


Building a Development Release
------------------------------

The peek package has build scripts that generate a development build

----

Open the command prompt and enter the bash shell

----

Change root directory of synerty-peek, example:

::

        cd ~peek/peek-dev/synerty-peek/


----

Run the follow command being sure to increment the version number:

::

        ./publish_platform.sh #.#.#.dev#


.. note:: Dev build, it doesn't tag, commit or test upload, but still generates a build.

.. warning:: Omitting the dot before dev will cause the script to fail as setuptools
    adds the dot in if it's not there, which means the cp commands won't match files.

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
