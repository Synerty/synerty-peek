.. _publish_peek_plugins:

====================
Publish Peek Plugins
====================

Public Packages
---------------

The Python Package Index
````````````````````````

The Python Package Index is a repository of software for the Python programming language.

.. _publish_peek_plugins_setting_up_your_pypi_accounts:

Setting up your PyPI Accounts
`````````````````````````````

First you will need to create your user accounts:

Test PyPI
~~~~~~~~~

Register here: `Test PyPI <https://testpypi.python.org/pypi>`_

PyPI
~~~~

Register here: `PyPI <https://pypi.python.org/pypi>`_

Create file :file:`~/.pypirc`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create file :file:`~/.pypirc` and populate with the following:

::

        [distutils]
        index-servers=
            pypi
            pypitest

        [pypitest]
        repository = https://testpypi.python.org/pypi
        username = <your user name goes here>
        password = <your password goes here>

        [pypi]
        repository = https://pypi.python.org/pypi
        username = <your user name goes here>
        password = <your password goes here>


.. note:: Make sure you update the :code:`username` and :code:`password`.

.. _publish_peek_plugins_register_a_plugin:

Register a Plugin
`````````````````

Before you can publicly upload a plugin, you need to register the Plugin on
`Test PyPI <https://testpypi.python.org/pypi>`_.

.. note:: Registration is only required for the test site.

Change root directory of peek-plugin, example:

::

        cd peek-plugin-example/


----

Run the following lines:

::

        python setup.py register -r pypitest


Expected Response:

::

        $ python setup.py register -r pypitest
        running register
        running egg_info
        writing top-level names to peek_plugin_tutorial.egg-info\top_level.txt
        writing dependency_links to peek_plugin_tutorial.egg-info\dependency_links.txt
        writing requirements to peek_plugin_tutorial.egg-info\requires.txt
        writing peek_plugin_tutorial.egg-info\PKG-INFO
        reading manifest file 'peek_plugin_tutorial.egg-info\SOURCES.txt'
        writing manifest file 'peek_plugin_tutorial.egg-info\SOURCES.txt'
        running check
        Registering peek-plugin-tutorial to https://testpypi.python.org/pypi
        Server response (200): OK


Generate a Production Release
-----------------------------

The peek package has build scripts that generate a platform build.

.. important:: Windows users must use bash.

----

Open the command prompt and enter the bash shell

----

Change root directory of peek-plugin, example:

::

        cd peek-plugin-example/


----

Ensure RELEASE_DIR is where you want it:

::

        echo $RELEASE_DIR


Create Private Plugin Release
`````````````````````````````

.. note:: Do not follow this step if you intend on using a public release, see
    :ref:`publish_peek_plugins_create_testpypi_public_release`

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


.. _publish_peek_plugins_create_testpypi_public_release:

Create TestPyPI Public Release
``````````````````````````````

Requirements:

- :ref:`publish_peek_plugins_setting_up_your_pypi_accounts`

- :ref:`publish_peek_plugins_register_a_plugin`

Ensure that the file :file:`publish.sh` variable :code:`PYPI_PUBLISH` is set to the
index of the test server defined in :file:`~/.pypirc`:

::

        # Leave blank not to publish
        # Or select one of the index servers defined in ~/.pypirc
        PYPI_PUBLISH="pypitest"


----

Run the follow command being sure to increment the version number:

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
        Submitting dist\peek-plugin-tutorial-0.0.7.tar.gz to https://testpypi.python.org/pypi
        Server response (200): OK


----

Check uploaded release on `Test PyPI <https://testpypi.python.org/pypi>`_.

----

Confirm release is functioning as expected before following the next step,
:ref:`publish_peek_plugins_create_pypi_public_release`

.. _publish_peek_plugins_create_pypi_public_release:

Create PyPI Public Release
``````````````````````````

Requirements:

- :ref:`publish_peek_plugins_create_testpypi_public_release`

Run the follow command:

::

        python setup.py sdist upload -r pypi


Expected response like:

::

        $ python setup.py sdist upload -r pypi
        running sdist

        ...

        running upload
        Submitting dist\peek-plugin-tutorial-0.0.7.tar.gz to https://upload.pypi.org/legacy/
        Server response (200): OK


----

Check uploaded release on `PyPI <https://pypi.python.org/pypi>`_.

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
