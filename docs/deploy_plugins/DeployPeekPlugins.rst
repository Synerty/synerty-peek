.. _deploy_peek_plugins:

===================
Deploy Peek Plugins
===================

.. note:: The Windows or Debian requirements must be followed before following this guide.

Deploying Plugins
-----------------

This section deploys the plugins to the new virtual environment.

For more information about plugin development and building plugin packages / releases
see: :ref:`develop_peek_plugins`

Windows
```````

Open a power shell window

----

CD to the folder where the plugin packages are located

----

Pip install the plugins with the following command

::

    # Activate the virtual environment
    # NOTE: Make sure you have the right virtual environment
    # Here we use "synerty-peek-0.1.0"

    $env:Path = "C:\Users\peek\synerty-peek-0.1.0\Scripts;$env:Path"

    # Install the plugin packages
    # NOTE: The dependencies were taken care of by pip wheel in the plugin release build
    pip install --no-deps $(ls * -name)
