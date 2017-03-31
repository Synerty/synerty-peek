.. _package_peek_plugins:

====================
Package Peek Plugins
====================

Packaging a Production Release
------------------------------

A release is a zip file containing all the required python packages to install
the plugins after the platform release has installed.

.. important:: Windows users must use bash.

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

Copy your private plugins into the release directory:

::

        cp ~/peek-plugin-example/dist/peek-plugin-example-#.#.#.tar.gz .


.. note:: Repeat this step for each private plugin.

----

Build Wheel archives for your private requirements and dependencies:

::

        pip wheel *.tar.gz


----

Build Wheel archives for your public requirements and dependencies:

::

        pip wheel peek-plugin-noop


.. note:: This is an example of a single plugin from
    `PyPI - the Python Package Index <https://pypi.python.org/pypi>`_.
    Include as many as you require in the single command line.

----

Cleanup the dist files directory:

::

        rm -rf *.tar.gz

Zip the contents:

::

        zip plugin_release_dir.zip *


----

Cleanup the release directory:

::

        rm -rf *.whl


What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
