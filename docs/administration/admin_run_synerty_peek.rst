.. _admin_run_synerty_peek:

Run Peek Manually
-----------------

This section describes the best practices for running the peek platform manually

----

To use bash on windows, install msys git. :ref:`setup_msys_git`, otherwise use
powershell on windows.

Check Environment
`````````````````

Make sure that the right environment is activated. Run the following commands.

----

PowerShell ::

        (Get-Command python).source
        (Get-Command run_peek_logic_service).source

Or Bash ::

        which python
        which run_peek_logic_service

----

Confirm that the output contains the release you wish to use.

run_peek_logic_service
``````````````````````

This section runs the peek server service of the platform and opens the admin page.

----

Run the following in bash, cmd or powershell ::

        run_peek_logic_service


----

Open the following URL in a browser, Chrome is recommended.

`<http://127.0.0.1:8010/>`_

This is the administration page for the peek platform, otherwise known as the
"Admin" service.


run_peek_office_service
```````````````````````

This section runs the peek client service, this serves the desktop and mobile web apps
and provides data to all desktop and mobile native apps

----

Run the following in bash, cmd or powershell ::

        run_peek_office_service


----

Open the following URL in a browser, Chrome is recommended.

`<http://127.0.0.1:8000/>`_

This is the mobile web app for the peek platform.


run_peek_agent_service
``````````````````````

The Agent is used to connect to external systems, this section runs the agent service.

----

Run the following in bash, cmd or powershell ::

        run_peek_agent_service


Whats Next
``````````

Now that the platform is running, See the next section,
:ref:`admin_update_plugin_settings`
