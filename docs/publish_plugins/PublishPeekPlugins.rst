.. _publish_peek_plugins:

====================
Publish Peek Plugins
====================

Public Packages
---------------

The Python Package Index
````````````````````````

The Python Package Index is a repository of software for the Python programming language.

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

Register a Plugin
`````````````````

Before you can publicly upload a plugin, you need to register the Plugin on
`Test PyPI <https://testpypi.python.org/pypi>`_ and
`PyPI <https://pypi.python.org/pypi>`_.

Change root directory of peek-plugin, example:

::

        cd ~peek/peek-plugin-example/


----

Run the following lines:

::

        python setup.py register -r https://testpypi.python.org/pypi
        python setup.py register


Generate a Production Release
-----------------------------

The peek package has build scripts that generate a platform build.

.. important:: Windows users must use bash.

----

Open the command prompt and enter the bash shell

----

Change root directory of peek-plugin, example:

::

        cd ~peek/peek-plugin-example/


Ensure RELEASE_DIR is where you want it:

::

        echo $RELEASE_DIR


Run the follow command being sure to increment the version number:

::

        ./publish.sh #.#.#


.. note:: For a public release run,
    :code:`./publish.sh #.#.# pypitest`.
    The script will upload your package to
    `Test PyPI <https://testpypi.python.org/pypi>`_

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
