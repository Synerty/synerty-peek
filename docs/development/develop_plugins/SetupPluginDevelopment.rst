.. _setup_plugin_for_development:

============================
Setup Plugin for Development
============================

Plugins need to be installed as python packages for the Peek Platform to run them.
This is typically done with a command similar to :command:`pip install peek-plugin-noop`.

Python packages can be installed in "development" mode, where your code being developed
is only linked into the python environment.

.. note:: For developing an existing plugin ensure there are no installed releases
   :code:`pip uninstall peek-plugin-example`.  Confirm installed peek packages with
   :code:`pip freeze | grep peek`.

This is achived with the following command in the plugin project root directory, where
setup.py is: ::

        # Check to ensure we're using the right python
        which python

        python setup.py develop


----

Configure Peek Services
```````````````````````

The python peek services, **worker**, **agent**, **field**,  **office**, and **logic** need to have
the plugin enabled in their :file:`~/peek-{service}/config.json`.

For example: ::

        "plugin": {
            "enabled": [
                "peek_plugin_example"
            ]
        }

----

Run the Plugin
``````````````

Now that the plugin has been setup for development and the platform has been configured
to run it, running the platform will run the plugin.

See the Setup IDE procedures to run the platform and debug plugins under those.

If a platform service, (:command:`run_peek_logic_service` for example) is run under the IDEs
debugger, it will also debug the plugins the platform loads.

Run the platform services from bash with the following commands: ::

        # Check to ensure we're using the right python
        which python

        # Run the peek logic service
        run_peek_logic_service

        # Run the peek office service
        run_peek_office_service

        # Run the peek field service
        run_peek_field_service

        # Run the peek agent
        run_peek_agent_service

        # Run the peek worker
        run_peek_worker_service


