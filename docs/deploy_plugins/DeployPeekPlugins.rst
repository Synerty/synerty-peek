.. _deploy_peek_plugins:

===================
Deploy Peek Plugins
===================

Deploying a Production Release
------------------------------

This section deploys the plugins to a virtual environment, see
:ref:`deploy_peek_platform`.

For more information about plugin development and building plugin packages / releases
see: :ref:`develop_peek_plugins`

.. important:: Windows users must use bash.

----

Download the :file:`plugin_release_dir.zip` file created in :ref:`package_peek_plugins`

----

Create the release directory:

::

        mkdir ~/plugin-release-dir


.. note::You may need to clean up any previously packaged releases:
    :code:`rm -rf ~/plugin-release-dir`

----

Change to release directory:

::

        cd ~/plugin-release-dir


----

Unzip the contents of :file:`plugin_release_dir.zip`:

::

        unzip ~/Downloads/plugin_release_dir.zip


----

Ensure that you're in the Virtual Environment that you want your plugins deployed:

::

        which python


----

Deploy the plugins:

::

        pip install --no-index --find-links=. peek-plugin*


----

Read through :ref:`administer_peek_platform` about updating the service
:file:`conf.json` files to include the deployed plugins.

----

Restart the :file:`server` service

----

You have successfully deployed your peek plugins

What Next?
----------

Refer back to the :ref:`how_to_use_peek_documentation` guide to see which document to
follow next.
