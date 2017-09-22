.. _publish_peek_plugins:

====================
Publish Peek Plugins
====================

The peek package has build scripts that generate a platform build.

.. important:: Windows users must use bash.

Create Private Plugin Release
-----------------------------

.. note:: Do not follow this step if you intend on using a public release, see
    :ref:`publish_peek_plugins_create_pypi_public_release`

Change root directory of peek-plugin, example:

::

        cd peek-plugin-example/


----

Ensure RELEASE_DIR is where you want the release:

::

        echo $RELEASE_DIR


----

Ensure that the file :file:`publish.sh` variable :code:`PYPI_PUBLISH` is blank

::

        # Leave blank not to publish
        # Or select one of the index servers defined in ~/.pypirc
        PYPI_PUBLISH=""


----

Run the follow command being sure to increment the version number:

::

        ./publish.sh #.#.#


Expected response like:

::

        $ ./publish.sh 0.0.7
        Setting version to 0.0.7

        ...

        Not publishing to any pypi indexes


.. _publish_peek_plugins_create_pypi_public_release:

Create PyPI Public Release
--------------------------

The Python Package Index is a repository of software for the Python programming language.

Setting up your PyPI Accounts
`````````````````````````````

First you will need to create your user account.

Register here: `PyPI <https://pypi.python.org/pypi>`_

Create file :file:`~/.pypirc`
`````````````````````````````

Create file :file:`~/.pypirc` and populate with the following:

::

        [distutils]
        index-servers=
            pypi

        [pypi]
        repository = https://pypi.python.org/pypi
        username = <your user name goes here>
        password = <your password goes here>


.. note:: Make sure you update the :code:`username` and :code:`password`.

Run script :file:`publish.sh`
`````````````````````````````

Change root directory of peek-plugin, example:

::

        cd peek-plugin-example/


----

Ensure RELEASE_DIR is where you want the release:

::

        echo $RELEASE_DIR


----

Ensure that the file :file:`publish.sh` variable :code:`PYPI_PUBLISH` is set to the
index of the PyPI server defined in :file:`~/.pypirc`:

::

        # Leave blank not to publish
        # Or select one of the index servers defined in ~/.pypirc
        PYPI_PUBLISH="pypi"


----

Run the follow command, being sure to increment the version number:

::

        ./publish.sh #.#.#


Expected response like:

::

        $ ./publish.sh 0.0.7
        Setting version to 0.0.7

        ...

        Writing peek-plugin-tutorial-0.0.7\setup.cfg
        Creating tar archive
        removing 'peek-plugin-tutorial-0.0.7' (and everything under it)
        running upload
        Submitting dist\peek-plugin-tutorial-0.0.7.tar.gz to https://upload.pypi.org/legacy/
        Server response (200): OK


----

Check uploaded release on `PyPI <https://pypi.python.org/pypi>`_.

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
