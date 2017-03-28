.. _publish_peek_plugins:

====================
Publish Peek Plugins
====================

Building a Production Release
-----------------------------

The peek package has build scripts that generate a platform build

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
    :code:`./publish.sh #.#.# peek-plugin-example`

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
